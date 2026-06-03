{ config, pkgs, lib, ... }:
{
  # Enables mDNS (.local) resolution and service publishing
  services.avahi = {
    enable = true;
    # Appends mdns_minimal [NOTFOUND=return] to /etc/nsswitch.conf for .local lookups
    nssmdns4 = true;
    # Publish services/hostname to LAN (multicast announcements)
    publish = {
      enable = true;
      # Advertises all IP addresses (helps cross-interface)
      addresses = true;
      # Publishes as "Workstation" service (browsable)
      workstation = true;
      domain = true;  # Includes domain
    };
  };
}

