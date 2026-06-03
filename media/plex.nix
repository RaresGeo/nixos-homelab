{ ... }:
let
  plexImage = "lscr.io/linuxserver/plex:latest";
  mediaDir = "/media";
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/plex-container 0755 root root -"
  ];

  virtualisation.oci-containers.containers.plex = {
    image = plexImage;
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Europe/Bucharest";
      VERSION = "docker";
      PLEX_CLAIM = "REDACTED";
    };
    volumes = [
      "/var/lib/plex-container:/config"
      "${mediaDir}:/media"
    ];
    extraOptions = [
      "--device=/dev/dri:/dev/dri"
      "--network=host"
    ];
  };
}
