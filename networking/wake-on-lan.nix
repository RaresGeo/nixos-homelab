{ config, lib, pkgs, ... }:

let
  cfg = config.services.homelab.wol;

  hostOptions = {
    options = {
      mac = lib.mkOption {
        type = lib.types.str;
        example = "18:c0:4d:dc:44:7b";
        description = "MAC address of the target's wake-capable NIC.";
      };

      broadcast = lib.mkOption {
        type = lib.types.str;
        default = "255.255.255.255";
        description = ''
          Address the magic packet is sent to. The subnet broadcast is more
          reliable than the global one, which some switches drop.
        '';
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Address polled by --wait. Leave empty to disable --wait.";
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 120;
        description = "How long --wait polls before giving up, in seconds.";
      };
    };
  };

  # One `wake-<name>` command per declared host.
  wakeScript = name: host: pkgs.writeShellScriptBin "wake-${name}" ''
    set -euo pipefail
    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.wakeonlan pkgs.iputils ]}

    wait=0
    for arg in "$@"; do
      case "$arg" in
        -w|--wait) wait=1 ;;
        -h|--help)
          echo "Usage: wake-${name} [--wait]"
          echo
          echo "Sends a Wake-on-LAN magic packet to ${name} (${host.mac})."
          echo "  -w, --wait  block until the host answers a ping (max ${toString host.timeout}s)"
          exit 0
          ;;
        *)
          echo "wake-${name}: unknown argument '$arg'" >&2
          exit 2
          ;;
      esac
    done

    echo "Waking ${name} (${host.mac}) via ${host.broadcast}..."
    # Repeat: a lone magic packet is easy to lose, and sending more is harmless.
    for _ in 1 2 3; do
      wakeonlan -i ${host.broadcast} ${host.mac} >/dev/null
      sleep 1
    done

    if [ "$wait" -eq 0 ]; then
      echo "Magic packet sent."
      exit 0
    fi

    ${lib.optionalString (host.address == "") ''
      echo "wake-${name}: --wait needs services.homelab.wol.hosts.${name}.address to be set." >&2
      exit 2
    ''}

    deadline=$(( $(date +%s) + ${toString host.timeout} ))
    printf 'Waiting for ${host.address}'
    while [ "$(date +%s)" -lt "$deadline" ]; do
      if ping -c 1 -W 1 -q ${host.address} >/dev/null 2>&1; then
        printf '\n${name} is up.\n'
        exit 0
      fi
      printf '.'
      sleep 2
    done

    printf '\n'
    echo "wake-${name}: timed out after ${toString host.timeout}s, ${name} did not answer." >&2
    exit 1
  '';
in
{
  options.services.homelab.wol.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule hostOptions);
    default = { };
    description = ''
      Hosts this machine can wake. Each entry gains a `wake-<name>` command,
      so the box can be powered on over SSH from anywhere Tailscale reaches.
    '';
  };

  config = {
    services.homelab.wol.hosts.desktop = {
      mac = "18:c0:4d:dc:44:7b";
      address = "192.168.100.10";
      broadcast = "192.168.100.255";
    };

    environment.systemPackages =
      [ pkgs.wakeonlan ] ++ lib.mapAttrsToList wakeScript cfg.hosts;
  };
}
