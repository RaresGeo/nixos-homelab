{ config, ... }:

let
  cfg = config.services.digital-hub;
in
{
  virtualisation.oci-containers.containers.digital-hub-web = {
    image = cfg.webImage;
    pull = "newer";
    autoStart = true;

    environment = {
      # SvelteKit's CSRF check compares form posts against this
      ORIGIN = "https://${cfg.webHost}";
    };
    # The node server listens on 3000 inside the container
    ports = [ "127.0.0.1:${toString cfg.webPort}:3000" ];
    extraOptions = [
      # Server-side loads call the API on its public URL; resolve that to the
      # host's nginx instead of hairpinning through the router
      "--add-host=${cfg.webHost}:host-gateway"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
