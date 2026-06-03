{ config, lib, pkgs, ... }:

let
  minioImage = "quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z";
  dataDir = "/var/lib/minio/data";
in
{
  virtualisation.oci-containers.containers."minio" = {
    image = minioImage;
    environment = {
      MINIO_ROOT_USER = "obsidian";
      MINIO_ROOT_PASSWORD = "%Queen7581Pawn%";
    };
    volumes = [
      "${dataDir}:/data"
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
    "d ${dataDir} 0750 minio minio - -"
  ];

  users.users.minio = {
    isSystemUser = true;
    group = "minio";
  };
  users.groups.minio = {};

  networking.firewall.allowedTCPPorts = [ 9000 9001 ];
}

