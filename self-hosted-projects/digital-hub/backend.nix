{ config, ... }:

let
  cfg = config.services.digital-hub;
in
{
  virtualisation.oci-containers.containers.digital-hub-backend = {
    image = cfg.backendImage;
    pull = "newer";
    autoStart = true;

    environmentFiles = [ cfg.environmentFile ];
    environment = {
      PORT = "8080";
      KEYDB_HOST = "keydb";
      FRONTEND_URL = "https://${cfg.webHost}";
      CMS_URL = "https://${cfg.cmsHost}";
      GOOGLE_REDIRECT_URL = "https://${cfg.webHost}/auth/callback";
      # Storefront and CMS are sibling subdomains; both need the login cookie
      COOKIE_DOMAIN = config.services.homelab.domain;
    };
    ports = [ "127.0.0.1:${toString cfg.backendPort}:8080" ];
    extraOptions = [
      "--network=digital-hub"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };

  systemd.services.podman-digital-hub-backend = {
    after = [ "digital-hub-postgres-healthcheck.service" "podman-digital-hub-keydb.service" ];
    requires = [ "digital-hub-postgres-healthcheck.service" "podman-digital-hub-keydb.service" ];
  };
}
