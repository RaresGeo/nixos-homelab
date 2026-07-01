{ config, pkgs, lib, ... }:
{
  # Enables mDNS (.local) resolution and service publishing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      domain = true;
    };
  };
}

