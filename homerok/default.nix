{ config, lib, ... }:

let
  domain = config.services.homelab.domain;
in
{
  imports = [
    ./container.nix
    ./acme.nix
    ./virtualhost.nix
  ];

  options.services.homerok = {
    port = lib.mkOption {
      type = lib.types.port;
      default = 4500;
      description = "Host port the server is published on (localhost only)";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/homerok-server:latest";
      description = ''
        homerok-server container image, including tag. It is built and
        pushed from the Mac (mise run push-image) through registry.<domain>,
        which is this same registry
      '';
    };

    tokensFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/homerok-tokens";
      description = ''
        One "<label> <token>" per line, mode 0600. Edits are picked up
        without a restart: a path unit copies it to where the container
        (uid 65532) can read it, and the server re-reads it on every connect
      '';
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "t";
      description = "Control host is <subdomain>.<domain>; tunnels are *.<subdomain>.<domain>";
    };

    host = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${config.services.homerok.subdomain}.${domain}";
      description = "Control host, derived from subdomain and the homelab domain";
    };
  };
}
