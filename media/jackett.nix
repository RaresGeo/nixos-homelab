{ config, ... }:

let
  cfg = config.services.media;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/jackett 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/jackett/.config 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/jackett/.config/Jackett 0775 ${cfg.users.primary} ${cfg.users.group} - -"
  ];

  services.jackett = {
    enable = true;
    user = cfg.users.primary;
    group = cfg.users.group;
    dataDir = "/var/lib/jackett";
  };
}
