{ config, ... }:

let
  cfg = config.services.media;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/radarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/radarr/.config 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/radarr/.config/Radarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "z /var/lib/radarr/.config/Radarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
  ];

  services.radarr = {
    enable = true;
    user = cfg.users.primary;
    group = cfg.users.group;
  };
}
