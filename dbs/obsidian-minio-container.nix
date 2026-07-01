{ config, lib, pkgs, ... }:

let
  cfg = config.services.obsidian-db;
in
{
  virtualisation.oci-containers.containers."minio" = {
    image = cfg.minioImage;
    environment = {
      MINIO_ROOT_USER = cfg.rootUser;
      MINIO_ROOT_PASSWORD = cfg.rootPassword;
    };
    volumes = [
      "${cfg.dataDir}:/data"
    ];
    ports = [
      "9000:9000"  # API
      "9001:9001"  # Console
    ];
    autoStart = true;
    cmd = [ "server" "/data" "--console-address" ":9001" ];
  };

  # Persistent storage
  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0750 minio minio - -"
  ];

  users.users.minio = {
    isSystemUser = true;
    group = "minio";
  };
  users.groups.minio = {};

  networking.firewall.allowedTCPPorts = [ 9000 9001 ];
}

