{
  services.dnsmasq = {
    enable = true;
    settings = {
      bind-interfaces = true;
      interface = "eno1";
      listen-address = "192.168.100.50";
      server = [ "1.1.1.1" "1.0.0.1" ];
      cache-size = 1000;
      bogus-priv = true;
      domain-needed = true;
      local = "/nixos.local/";
      expand-hosts = true;

      # Subdomains → homelab nginx reverse proxy
      address = [
        "/nixos.local/192.168.100.50"
        "/plex.nixos.local/192.168.100.50"
        "/transmission.nixos.local/192.168.100.50"
        "/radarr.nixos.local/192.168.100.50"
        "/jackett.nixos.local/192.168.100.50"
        "/bazarr.nixos.local/192.168.100.50"
        "/minio.nixos.local/192.168.100.50"
        "/finance.nixos.local/192.168.100.50"
        "/copyparty.nixos.local/192.168.100.50"
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}

