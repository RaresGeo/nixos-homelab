{ config, ... }:

let
  cfg = config.services.finance;
in
{
  virtualisation.oci-containers.containers.finance-discord = {
    image = cfg.discordImage;
    pull = "newer";
    autoStart = true;

    volumes = [
      "${cfg.dataDir}:/data"
    ];
    environmentFiles = [ cfg.environmentFile ];
    environment = {
      DB_PATH = "/data/finance.db";
    };

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
