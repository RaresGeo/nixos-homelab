{ config, lib, pkgs, ... }:

let
  cfg = config.services.laravel-tierlist;
in
{
  imports = [
    ./network.nix
    ./web.nix
    ./php-fpm.nix
    ./virtualhost.nix
  ];

  options.services.laravel-tierlist = {
    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/laravel-tierlist.env";
      description = "Env file with APP_KEY and other secrets";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/laravel-tierlist/data";
    };

    imagesDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/laravel-tierlist/images";
      description = ''
        Host dir for images, uses uid and guid 33
        So php-fpm pool workers can actually save/read images
      '';
    };

    webServerImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/tierlist-web:latest";
      description = "Web server image, default to :latest";
    };

    phpFpmImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/tierlist-php:latest";
      description = "PHP FPM image, containing the Laravel project itself, default to :latest";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8001;
      description = "Host port the web server is served over (localhost only)";
    };
  };
}
