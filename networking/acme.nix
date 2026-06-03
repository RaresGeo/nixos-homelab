{
  security.acme = {
    acceptTerms = true;
    defaults.email = "raresgeo9@gmail.com";
    certs."kryllix.dedyn.io" = {
      domain = "kryllix.dedyn.io";
      extraDomainNames = [ "*.kryllix.dedyn.io" ];
      dnsProvider = "desec";
      credentialsFile = "/etc/nixos/secrets/desec-token";
      group = "nginx";
    };
  };
}
