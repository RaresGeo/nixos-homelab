{ config, pkgs, ... }:

let
  copypartyImage = "copyparty/ac:1.20.10";
  dataDir = "/var/lib/copyparty/data";
  copypartyConf = pkgs.writeText "copyparty.conf" ''
    [global]
    # p: 3923
    xf-proto: X-Forwarded-Proto
    xf-host: X-Forwarded-Host
    xff-src: lan
    rproxy: -1

    [accounts]
    daniel: athome

    [/]
    /data
    accs:
      rwdma: daniel
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
          -v ${dataDir}:/data \
          -p 3923:3923 \
          ${copypartyImage}
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop copyparty";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 daniel users - -"
  ];
}
