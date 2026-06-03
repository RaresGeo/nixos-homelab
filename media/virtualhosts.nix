{
  services.nginx.virtualHosts = {
    "bazarr.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:6767";
        proxyWebsockets = true;
      };
    };
    "jackett.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9117";
        proxyWebsockets = true;
      };
    };
    "plex.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
        proxyWebsockets = true;
      };
    };
    "radarr.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
        proxyWebsockets = true;
      };
    };
    "transmission.kryllix.dedyn.io" = {
      useACMEHost = "kryllix.dedyn.io";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true;
      };
    };
  };
}
