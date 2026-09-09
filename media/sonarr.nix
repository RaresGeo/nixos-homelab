{ config, ... }:

let
  cfg = config.services.media;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/sonarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/sonarr/.config 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "d /var/lib/sonarr/.config/NzbDrone 0775 ${cfg.users.primary} ${cfg.users.group} - -"
    "z /var/lib/sonarr/.config/NzbDrone 0775 ${cfg.users.primary} ${cfg.users.group} - -"
  ];

  services.sonarr = {
    enable = true;
    user = cfg.users.primary;
    group = cfg.users.group;
  };
}
