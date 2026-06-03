{ config, ... }:

let
  media = config.media.users;
in {
  # Define the shared media group with all service users
  users.groups.${media.group}.members = [ 
    media.primary 
    "plex" 
    "transmission" 
  ];

  systemd.tmpfiles.rules = [
    "d /media/movies 0775 plex ${media.group} - -"
    "d /media/downloads 0775 plex ${media.group} - -"
    "d /media/tvshows 0775 plex ${media.group} - -"
    "d /media/incomplete 0775 ${media.primary} ${media.group} - -"
    "d /media/watch 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/radarr 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/radarr/.config 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/radarr/.config/Radarr 0775 ${media.primary} ${media.group} - -"
    "z /var/lib/radarr/.config/Radarr 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/bazarr 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/jackett 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/jackett/.config 0775 ${media.primary} ${media.group} - -"
    "d /var/lib/jackett/.config/Jackett 0775 ${media.primary} ${media.group} - -"
  ];
}

