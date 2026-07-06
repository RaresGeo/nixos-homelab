{config, lib, ...}:

let
  cfg = config.services.homelab;
in
{
  imports = [
    ./acme.nix
    ./ahavi.nix
    ./ddclient.nix
    ./nginx.nix
    ./tailscale.nix
  ];

  options.services.homelab = {
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Base domain for the reachable host";
    };

    acmeEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email address for ACME cert registration";
    };

    desecTokenFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/desec-token";
    };

    basicAuthFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/registry-htpasswd";
    };
  };
}
