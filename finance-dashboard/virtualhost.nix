{ config, ... }:
let
  domain = config.services.homelab.domain;
in
{
  services.nginx.virtualHosts."finance.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations = {
      "/" = {
        alias = "/var/www/finance-frontend/dist/";
        tryFiles = "$uri $uri/ /index.html";
        index = "index.html";
      };
      "/api/" = {
        proxyPass = "http://127.0.0.1:8000/api/";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
