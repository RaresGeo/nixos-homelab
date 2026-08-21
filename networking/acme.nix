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

  # The wildcard CNAME also matches _acme-challenge, so lego would follow it to
  # the apex and deSEC rejects a TXT record with an empty subname.
  systemd.services."acme-order-renew-${cfg.domain}".environment.LEGO_DISABLE_CNAME_SUPPORT = "true";
}
