{ config, ... }:

let
  homelab = config.services.homelab;
  cfg = config.services.homerok;
in
{
  # *.t.<domain> is a level below the apex wildcard cert, so it needs its own.
  # The control host t.<domain> itself is covered by the existing *.<domain>.
  security.acme.certs."${cfg.host}" = {
    domain = "*.${cfg.host}";
    dnsProvider = "desec";
    credentialsFile = homelab.desecTokenFile;
    group = "nginx";
    # deSEC's secondaries can lag well behind lego's propagation check, which
    # then times out ("ns2.desec.org did not return the expected TXT record").
    # Ask deSEC directly and just wait instead of checking. The *.t CNAME
    # means lego may put the TXT on the apex; Let's Encrypt follows the same
    # CNAME, so validation still finds it.
    extraLegoFlags = [ "--dns.resolvers" "ns1.desec.io:53" "--dns.propagation-wait" "300s" ];
  };

  # The *.t wildcard CNAME also matches _acme-challenge.t, so lego would
  # follow it to the apex; same override as the apex cert.
  systemd.services."acme-order-renew-${cfg.host}".environment.LEGO_DISABLE_CNAME_SUPPORT = "true";
}
