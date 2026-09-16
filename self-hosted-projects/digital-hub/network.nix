{ config, ... }:
let
  podman = config.virtualisation.podman.package;
in
{
  systemd.services.podman-network-digital-hub = {
    description = "Create podman network for digital-hub";
    after = [ "podman.service" ];
    requires = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/sh -c '${podman}/bin/podman network create digital-hub || true'";
    };
  };
}
