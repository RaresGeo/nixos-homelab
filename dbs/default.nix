{ config, lib, pkgs, ... }:

let
  cfg = config.services.obsidian-db;
in
{
  imports = [
    ./minio-virtualhosts.nix
    ./obsidian-minio-container.nix
    ./larvel-mariadb-container.nix
  ];
  options.services.obsidian-db = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/minio/data";
    };

    minioImage = lib.mkOption {
      type = lib.types.str;
      default = "quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z";
      description = "minIO image";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/obsidian-db.env";
      description = "Env file with root username and root password";
    };
  };

  options.services.laravel-db = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/mariadb/data";
    };

    mariadbImage = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/mariadb:10.6";
      description = "mariadb image";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/laravel-db.env";
      description = "Env file with root username and root password";
    };
  };
}
