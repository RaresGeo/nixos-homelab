{config, lib, ...}:

let
  cfg = config.services.homelab;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = cfg.acmeEmail;

    certs."${cfg.domain}" = {
      domain = cfg.domain;
      extraDomainNames = [ "*.${cfg.domain}" ];
      dnsProvider = "desec";
      credentialsFile = cfg.desecTokenFile;
      group = "nginx";
    };
  };
}
