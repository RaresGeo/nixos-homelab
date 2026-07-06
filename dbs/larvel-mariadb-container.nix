{ config, lib, pkgs, ... }:

let
  cfg = config.services.laravel-db;
in
{
  virtualisation.oci-containers.containers.mariadb = {
    image = cfg.mariadbImage;
    environmentFiles = [ cfg.environmentFile ];
    volumes = [
      "${cfg.dataDir}:/var/lib/mysql"
    ];
    autoStart = true;
    extraOptions = [
      "--network=laravel-tierlist"
      "--health-cmd=healthcheck.sh --connect --innodb_initialized"
      "--health-interval=10s"
      "--health-timeout=5s"
      "--health-retries=5"
      "--health-start-period=30s"
    ];
  };

  systemd.services.podman-mariadb = {
    after = [ "podman-network-laravel-tierlist.service" ];
    requires = [ "podman-network-laravel-tierlist.service" ];
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0750 mariadb mariadb - -"
  ];

  users.users.mariadb = {
    isSystemUser = true;
    group = "mariadb";
  };
  users.groups.mariadb = {};

  systemd.services.mariadb-healthcheck = {
    description = "Wait for MariaDB container to be healthy";
    after = [ "podman-mariadb.service" ];
    requires = [ "podman-mariadb.service" ];
    before = [ "podman-laravel-tierlist-php-fpm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for i in $(seq 1 18); do
        status=$(${pkgs.podman}/bin/podman inspect --format '{{.State.Health.Status}}' mariadb || echo "starting")
        if [ "$status" = "healthy" ]; then
          exit 0
        fi
        sleep 5
      done
      echo "mariadb did not become healthy in time"
      exit 1
    '';
  };
}

