{
  services.nginx.virtualHosts = {
    "minio.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9001";
        proxyWebsockets = true;
      };
    };
    "minio-api.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9000";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          proxy_buffering off;
          proxy_request_buffering off;
        '';
      };
    };
  };
}
