{ config, ... }:

let
  cfg = config.services.laravel-tierlist;
in
{
  virtualisation.oci-containers.containers.laravel-tierlist-php-fpm = {
    image = cfg.phpFpmImage;
    pull = "newer";
    autoStart = true;

    volumes = [
      "${cfg.dataDir}:/var/www/storage"
    ];
    environmentFiles = [ cfg.environmentFile ];
    extraOptions = [
      "--network=laravel-tierlist"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0755 root root - -"
  ];

  systemd.services.podman-laravel-tierlist-php-fpm = {
    after = [ "mariadb-healthcheck.service" ];
    requires = [ "mariadb-healthcheck.service" ];
  };
}
