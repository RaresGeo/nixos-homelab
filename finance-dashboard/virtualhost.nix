{
  services.nginx.virtualHosts."finance.kryllix.dedyn.io" = {
    useACMEHost = "kryllix.dedyn.io";
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
