{ config, pkgs, ... }:
{
  systemd.services."finance-backend" = {
    description = "Finance Dashboard Backend";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "daniel";
      Group = "users";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      ExecStartPre = "-${pkgs.podman}/bin/podman rm -f finance-backend";
      ExecStart = ''
        ${pkgs.podman}/bin/podman run --name finance-backend --rm \
          -v /home/daniel/finance-bot/data:/data \
          --env-file /home/daniel/finance-bot/.env \
          -e DB_PATH=/data/finance.db \
          -e CORS_ORIGIN=* \
          -p 127.0.0.1:8000:8000 \
          localhost/finance-backend:latest
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop finance-backend";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
