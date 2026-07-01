{ config, ... }:
let
  domain = config.services.homelab.domain;
in
{
  services.nginx.virtualHosts."copyparty.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3923";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;
        proxy_buffering off;
        proxy_request_buffering off;
      '';
    };
  };
}
