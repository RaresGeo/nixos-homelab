{ config, ... }:
let
  domain = config.services.homelab.domain;
in
{
  services.nginx.virtualHosts."${domain}" = {
    default = true;
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      root = "/var/www/dashboard";
      index = "index.html";
    };
  };
}

