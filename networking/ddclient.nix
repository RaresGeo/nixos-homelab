{
  services.ddclient = {
    enable = true;
    protocol = "desec";
    username = "kryllix.dedyn.io";
    passwordFile = "/etc/nixos/secrets/desec-token";
    domains = [ "kryllix.dedyn.io" ];
    interval = "5min";
  };
}
