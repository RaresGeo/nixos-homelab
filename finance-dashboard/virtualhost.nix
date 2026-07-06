{ config, ... }:

let
  domain = config.services.homelab.domain;
  cfg = config.services.finance;
in
{
  services.nginx.virtualHosts."finance.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.frontendPort}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
      "/api/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}/api/";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
