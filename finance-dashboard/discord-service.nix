{ config, pkgs, ... }:
{
  systemd.services."finance-discord" = {
    description = "Finance Dashboard Discord Service (data getter)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "daniel";
      Group = "users";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      ExecStartPre = "-${pkgs.podman}/bin/podman rm -f finance-discord";
      ExecStart = ''
        ${pkgs.podman}/bin/podman run --name finance-discord --rm \
          -v /home/daniel/finance-bot/data:/data \
          --env-file /home/daniel/finance-bot/.env \
          -e DB_PATH=/data/finance.db \
          localhost/finance-discord:latest
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop finance-discord";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
