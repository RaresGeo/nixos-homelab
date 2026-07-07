{ config, ... }:

let
  domain = config.services.homelab.domain;
  cfg = config.services.dashboard;
in
{
  services.nginx.virtualHosts."${domain}" = {
    default = true;
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      root = cfg.stateDir;
      index = "index.html";
    };
  };
}
