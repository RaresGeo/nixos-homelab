{ config, ... }:

let
  plexImage = "lscr.io/linuxserver/plex:latest";
  cfg = config.services.media;
in
{
  users.groups.${cfg.users.group} = {
    members = [ "plex" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/plex-container 0755 root root -"
    "d ${cfg.mediaDir}/movies 0775 plex ${cfg.users.group} - -"
    "d ${cfg.mediaDir}/tvshows 0775 plex ${cfg.users.group} - -"
  ];

  virtualisation.oci-containers.containers.plex = {
    image = plexImage;
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = cfg.timezone;
      VERSION = "docker";
      PLEX_CLAIM = cfg.plex.claimToken;
    };
    volumes = [
      "/var/lib/plex-container:/config"
      "${cfg.mediaDir}:/media"
    ];
    extraOptions = [
      "--device=/dev/dri:/dev/dri"
      "--network=host"
    ];
  };
}
