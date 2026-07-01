{ config, ... }:

let
  cfg = config.services.homelab;
in
{
  virtualisation.oci-containers.containers.registry = {
    image = "registry:2";
    pull = "always";
    ports = [ "127.0.0.1:5000:5000" ];
    volumes = [ "/var/lib/registry:/var/lib/registry" ];
  };

  virtualisation.containers.registries.insecure = [ "localhost:5000" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/registry 0755 root root -"
  ];

  services.nginx.virtualHosts."registry.${cfg.domain}" = {
    forceSSL = true;
    useACMEHost = cfg.domain;
    basicAuthFile = cfg.basicAuthFile;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5000";
      extraConfig = ''
        client_max_body_size 0;
      '';
    };
  };
}
