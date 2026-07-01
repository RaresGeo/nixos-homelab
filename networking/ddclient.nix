{config, ...}:

let 
  cfg = config.services.homelab;
in
{
  services.ddclient = {
    enable = true;
    protocol = "desec";
    username = cfg.domain;
    passwordFile = toString cfg.desecTokenFile;
    domains = [ "${cfg.domain}" ];
    interval = "5min";
  };
}
