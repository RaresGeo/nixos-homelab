{ config, lib, pkgs, ... }:

let
  cfg = config.services.obsidian-db;
in
{
  imports = [
    ./minio-virtualhosts.nix
    ./obsidian-minio-container.nix
  ];
  options.services.obsidian-db = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/minio/data";
    };

    minioImage = lib.mkOption {
      type = lib.types.str;
      default = "quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z";
      description = "minIO container image, including tag";
    };

    rootUser = lib.mkOption {
      type = lib.types.str;
      description = "username of minIO root user";
    };

    rootPassword = lib.mkOption {
      type = lib.types.str;
      description = "Password for minIO root user";
    };
  };
}
