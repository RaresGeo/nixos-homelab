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
  };

  # The *.t wildcard CNAME also matches _acme-challenge.t, so lego would
  # follow it to the apex; same fix as the apex cert.
  systemd.services."acme-order-renew-${cfg.host}".environment.LEGO_DISABLE_CNAME_SUPPORT = "true";
}
