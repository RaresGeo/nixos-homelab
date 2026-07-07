{ config, lib, ... }:

let
  cfg = config.services.dashboard;
in
{
  imports = [
    ./bare-repo.nix
    ./virtualhost.nix
  ];

  options.services.dashboard = {
    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/www/dashboard";
      description = "Web root the dashboard is checked out to and served from";
    };

    bareRepoDir = lib.mkOption {
      type = lib.types.path;
      default = "/home/daniel/bare-repos/.dashboard.git";
      description = "Bare git repo that receives pushes and deploys the dashboard";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Branch whose pushes trigger a deploy";
    };

    pushUser = lib.mkOption {
      type = lib.types.str;
      default = "daniel";
      description = "User that owns the bare repo and web root and pushes to deploy";
    };
  };
}
