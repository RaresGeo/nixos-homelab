{ config, ... }:

let
  domain = config.services.homelab.domain;
  cfg = config.services.laravel-tierlist;
in
{
  services.nginx.virtualHosts."tierlists.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.port}";
      recommendedProxySettings = true;
      proxyWebsockets = true;
    };
  };
}
