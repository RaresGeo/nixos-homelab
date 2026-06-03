{ config, lib, pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.daniel.extraGroups = [ "podman" ];

  environment.systemPackages = with pkgs; [
    podman-compose  # docker-compose compat
  ];

  virtualisation.oci-containers.backend = "podman";
}
