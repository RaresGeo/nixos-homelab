{ config, lib, ... }:

let
  cfg = config.services.finance;
in
{
  imports = [
    ./backend.nix
    ./discord-service.nix
    ./frontend.nix
    ./virtualhost.nix
  ];

  options.services.finance = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/finance/data";
      description = "Directory holding the finance database and state";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/finance.env";
      description = "Env file with finance secrets (Discord token, etc.)";
    };

    backendImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/finance-backend:latest";
      description = "Backend container image, including tag";
    };

    discordImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/finance-discord:latest";
      description = "Discord service container image, including tag";
    };

    corsOrigin = lib.mkOption {
      type = lib.types.str;
      default = "https://finance.${config.services.homelab.domain}";
      description = "Allowed CORS origin for the backend API";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Host port the backend API is published on (localhost only)";
    };

    frontendImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/finance-frontend:latest";
      description = "Frontend container image, including tag";
    };

    frontendPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Host port the frontend container is published on (localhost only)";
    };
  };
}
