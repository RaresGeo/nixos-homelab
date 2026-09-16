{ config, ... }:

let
  domain = config.services.homelab.domain;
  cfg = config.services.digital-hub;

  # Both hosts expose the API under /api/, with the prefix stripped
  api = {
    proxyPass = "http://127.0.0.1:${toString cfg.backendPort}/";
    recommendedProxySettings = true;
    extraConfig = ''
      client_max_body_size 100m;
    '';
  };
in
{
  services.nginx.virtualHosts = {
    "${cfg.webHost}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.webPort}";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };
        "/api/" = api;
        # Google's OAuth callback, unprefixed: the backend checks the path it
        # receives against GOOGLE_REDIRECT_URL, so they have to be the same
        "= /auth/callback" = {
          proxyPass = "http://127.0.0.1:${toString cfg.backendPort}";
          recommendedProxySettings = true;
        };
      };
    };
    "${cfg.cmsHost}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.cmsPort}";
          recommendedProxySettings = true;
        };
        "/api/" = api;
      };
    };
  };
}
