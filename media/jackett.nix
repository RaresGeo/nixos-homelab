{ config, ... }:

let
	media = config.media.users;
in
{
  imports = [ ./media.nix ];

  services.jackett = {
    enable = true;
    user = media.primary;
    group = media.group;
    dataDir = "/var/lib/jackett";
  };

}

