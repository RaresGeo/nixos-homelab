{ config, pkgs, ... }:

let
	media = config.media.users;
in
{
  imports = [ ./media.nix ];  

  services.bazarr = {
    enable = true;
    user = media.primary;
    group = media.group;
    dataDir = "/var/lib/bazarr";  
  };
}

