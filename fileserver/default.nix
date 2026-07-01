{ config, lib, ... }:

let
  cfg = config.services.fileserver;
in
{
  imports = [
    ./copyparty.nix
    ./virtualhost.nix
  ];

  options.services.fileserver = {
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/copyparty/data";
      description = "Directory where copyparty stores its data";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "copyparty/ac:1.20.10";
      description = "Copyparty container image, including tag";
    };

    accounts = lib.mkOption {
      default = [ ];
      description = "Copyparty user accounts granted full access to the share";
      type = lib.types.listOf (lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            description = "Account username";
          };
          password = lib.mkOption {
            type = lib.types.str;
            description = "Account password";
          };
        };
      });
    };
  };
}
