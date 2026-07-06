{ config, ... }:

let
  cfg = config.services.finance;
in
{
  virtualisation.oci-containers.containers.finance-frontend = {
    image = cfg.frontendImage;
    autoStart = true;

    # The image serves the built SPA on port 80 (nginx inside the container);
    # publish it on localhost so the host nginx can reverse-proxy to it.
    ports = [ "127.0.0.1:${toString cfg.frontendPort}:80" ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
