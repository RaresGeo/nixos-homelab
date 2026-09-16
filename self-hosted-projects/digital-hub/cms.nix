{ config, ... }:

let
  cfg = config.services.digital-hub;
in
{
  virtualisation.oci-containers.containers.digital-hub-cms = {
    image = cfg.cmsImage;
    pull = "newer";
    autoStart = true;

    # The image serves the built SPA on port 80 (nginx inside the container);
    # publish it on localhost so the host nginx can reverse-proxy to it.
    ports = [ "127.0.0.1:${toString cfg.cmsPort}:80" ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
