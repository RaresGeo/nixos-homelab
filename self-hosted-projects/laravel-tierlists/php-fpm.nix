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
      "${cfg.imagesDir}:/var/www/public/images"
    ];
    environmentFiles = [ cfg.environmentFile ];
    extraOptions = [
      "--network=laravel-tierlist"
      # the nginx config uses php-fpm so alias it
      "--network-alias=php-fpm"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0755 root root - -"
    # php-fpm pool workers (www-data, with uid and gid `33`) upload images here
    # World readable so nginx can read despite `33` uid and gid owner
    "d ${cfg.imagesDir} 0755 33 33 - -"
  ];

  systemd.services.podman-laravel-tierlist-php-fpm = {
    after = [ "mariadb-healthcheck.service" ];
    requires = [ "mariadb-healthcheck.service" ];
  };
}
