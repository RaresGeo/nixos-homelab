{ config, ... }:

let
  cfg = config.services.laravel-tierlist;
in
{
  virtualisation.oci-containers.containers.laravel-tierlist-web = {
    image = cfg.webServerImage;
    autoStart = true;

    volumes = [
      "${cfg.dataDir}:/var/www/storage:ro"
    ];
    environmentFiles = [ cfg.environmentFile ];
    ports = [ "127.0.0.1:${toString cfg.port}:80" ];
    extraOptions = [
      "--network=laravel-tierlist"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };

  systemd.services.podman-laravel-tierlist-web = {
    after = [ "podman-laravel-tierlist-php-fpm.service" ];
    requires = [ "podman-laravel-tierlist-php-fpm.service" ];
  };
}
