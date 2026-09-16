{ config, lib, ... }:

let
  cfg = config.services.digital-hub;
  domain = config.services.homelab.domain;
in
{
  imports = [
    ./network.nix
    ./postgres.nix
    ./keydb.nix
    ./backend.nix
    ./web.nix
    ./cms.nix
    ./virtualhost.nix
  ];

  options.services.digital-hub = {
    environmentFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/secrets/digital-hub.env";
      description = ''
        Env file shared by postgres and the backend: POSTGRES_* credentials,
        DATABASE_URL, JWT_SECRET, Google OAuth, AWS S3 and Stripe secrets
      '';
    };

    postgresDataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/digital-hub/postgres";
    };

    keydbDataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/digital-hub/keydb";
    };

    postgresImage = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/library/postgres:16.1-alpine";
      description = "postgres image";
    };

    keydbImage = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/eqalpha/keydb:alpine_x86_64_v6.3.4";
      description = "keydb image";
    };

    backendImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/digital-hub-backend:staging";
      description = "Backend (Deno API) container image, including tag";
    };

    webImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/digital-hub-web:staging";
      description = "Storefront (SvelteKit) container image, including tag";
    };

    cmsImage = lib.mkOption {
      type = lib.types.str;
      default = "localhost:5000/digital-hub-cms:staging";
      description = "CMS (static SPA) container image, including tag";
    };

    webHost = lib.mkOption {
      type = lib.types.str;
      default = "digitalhub.${domain}";
      description = ''
        Storefront host, also serving the API under /api/. They must share a
        host: the storefront's server-side load reads the API's jwt cookie
      '';
    };

    cmsHost = lib.mkOption {
      type = lib.types.str;
      default = "digitalhub-cms.${domain}";
      description = "CMS host, also proxying the API under /api/";
    };

    backendPort = lib.mkOption {
      type = lib.types.port;
      default = 8010;
      description = "Host port the backend API is published on (localhost only)";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8011;
      description = "Host port the storefront is published on (localhost only)";
    };

    cmsPort = lib.mkOption {
      type = lib.types.port;
      default = 8012;
      description = "Host port the CMS is published on (localhost only)";
    };
  };
}
