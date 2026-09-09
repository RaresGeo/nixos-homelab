{ config, ... }:

let
  cfg = config.services.media;
in
{
  users.groups.${cfg.users.group} = {
    members = [ "transmission" ];
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.mediaDir}/downloads 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d ${cfg.mediaDir}/downloads/radarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d ${cfg.mediaDir}/downloads/sonarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d ${cfg.mediaDir}/incomplete 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d ${cfg.mediaDir}/watch 0775 ${cfg.users.primary} ${cfg.users.group} - -"
  ];

  services.transmission = {
    enable = true;
    user = cfg.users.primary;
    group = cfg.users.group;

    openRPCPort = true;

    settings = {
      download-dir = "${cfg.mediaDir}/downloads";
      incomplete-dir = "${cfg.mediaDir}/incomplete";
      incomplete-dir-enabled = true;
      watch-dir = "${cfg.mediaDir}/watch";

      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = false;
      rpc-whitelist = "127.0.0.1,192.168.100.50,nixos.local,nixos.*.ts.net";
      rpc-authentication-required = true;
      rpc-username = "daniel";
      rpc-password = cfg.transmission.password;
    };
  };
}
