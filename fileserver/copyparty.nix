{ config, lib, pkgs, ... }:

let
  cfg = config.services.fileserver;

  usernames = map (a: a.username) cfg.accounts;
  accountLines = lib.concatMapStringsSep "\n" (a: "${a.username}: ${a.password}") cfg.accounts;

  copypartyConf = pkgs.writeText "copyparty.conf" ''
    [global]
    # p: 3923
    xf-proto: X-Forwarded-Proto
    xf-host: X-Forwarded-Host
    xff-src: lan
    rproxy: -1

    [accounts]
    ${accountLines}

    [/]
    /data
    accs:
      rwdma: ${lib.concatStringsSep "," usernames}
  '';
in
{
  systemd.services."copyparty" = {
    description = "Copyparty file server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "daniel";
      Group = "users";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      ExecStartPre = "-${pkgs.podman}/bin/podman rm -f copyparty";
      ExecStart = ''
        ${pkgs.podman}/bin/podman run --name copyparty --rm \
          -v ${copypartyConf}:/cfg/copyparty.conf:ro \
          -v ${cfg.dataDir}:/data \
          -p 3923:3923 \
          ${cfg.image}
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop copyparty";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0750 daniel users - -"
  ];
}
