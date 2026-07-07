{ config, lib, ... }:

let
  cfg = config.services.media;
  users = cfg.users;
in
{
  imports = [
    ./bazarr.nix
    ./jackett.nix
    ./plex.nix
    ./radarr.nix
    ./transmission.nix
    ./virtualhosts.nix
  ];

  options.services.media = {
    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = "/media";
      description = "Base directory for media";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = config.time.timeZone;
      description = "Timezone for media services";
    };

    users = {
      primary = lib.mkOption {
        type = lib.types.str;
        description = "Primary user for media services";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "media";
        description = "Shared group for media access";
      };
    };

    plex.claimToken = lib.mkOption {
      type = lib.types.str;
      description = "Plex claim token (from https://plex.tv/claim)";
    };

    # Switch to a .env file or password manager, as this password is stored in the NixOS store
    transmission.password = lib.mkOption {
      type = lib.types.str;
      description = "Transmission RPC password";
    };
  };

  config = {
    users.users.${users.primary}.extraGroups = [ users.group ];

    users.groups.${users.group} = {
      members = [ users.primary ];
    };
  };
}
