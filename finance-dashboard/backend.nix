{ config, ... }:

let
  cfg = config.services.finance;
in
{
  virtualisation.oci-containers.containers.finance-backend = {
    image = cfg.backendImage;
    autoStart = true;

    volumes = [
      "${cfg.dataDir}:/data"
    ];
    environmentFiles = [ cfg.environmentFile ];
    environment = {
      DB_PATH = "/data/finance.db";
      CORS_ORIGIN = cfg.corsOrigin;
    };
    ports = [ "127.0.0.1:${toString cfg.port}:8000" ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
