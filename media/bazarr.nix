{ config, ... }:

let
  cfg = config.services.media;
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/bazarr 0775 ${cfg.users.primary} ${cfg.users.group} - -"
  ];

  services.bazarr = {
    enable = true;
    user = cfg.users.primary;
    group = cfg.users.group;
    dataDir = "/var/lib/bazarr";
  };
}
