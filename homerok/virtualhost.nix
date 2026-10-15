{ config, ... }:

let
  domain = config.services.homelab.domain;
  cfg = config.services.homerok;
  upstream = "http://127.0.0.1:${toString cfg.port}";
in
{
  services.nginx.virtualHosts = {
    # Control endpoint: the clients' long-lived WebSocket, plus status.
    "${cfg.host}" = {
      useACMEHost = domain;
      forceSSL = true;
      locations."/" = {
        proxyPass = upstream;
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 1h;
        '';
      };
    };

    # Tunnels. Bodies and responses stream straight through (uploads, SSE),
    # and proxied WebSockets may stay open for a long time.
    "*.${cfg.host}" = {
      useACMEHost = cfg.host;
      forceSSL = true;
      locations."/" = {
        proxyPass = upstream;
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_request_buffering off;
          client_max_body_size 0;
          proxy_read_timeout 1h;
          proxy_send_timeout 1h;
        '';
      };
    };
  };
}
