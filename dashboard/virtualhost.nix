{
  services.nginx.virtualHosts."kryllix.dedyn.io" = {
    default = true;
    useACMEHost = "kryllix.dedyn.io";
    forceSSL = true;
    locations."/" = {
      root = "/var/www/dashboard";
      index = "index.html";
    };
  };
}

