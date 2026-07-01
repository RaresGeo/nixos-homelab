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
        alias = "${cfg.frontendDir}/";
        tryFiles = "$uri $uri/ /index.html";
        index = "index.html";
      };
      "/api/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}/api/";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
