{ config, ... }:

let
  cfg = config.services.digital-hub;
in
{
  virtualisation.oci-containers.containers.digital-hub-keydb = {
    image = cfg.keydbImage;
    volumes = [
      "${cfg.keydbDataDir}:/data"
    ];
    autoStart = true;
    cmd = [ "keydb-server" "--appendonly" "yes" ];
    extraOptions = [
      "--network=digital-hub"
      "--network-alias=keydb"
    ];
  };

  systemd.services.podman-digital-hub-keydb = {
    after = [ "podman-network-digital-hub.service" ];
    requires = [ "podman-network-digital-hub.service" ];
  };

  systemd.tmpfiles.rules = [
    "d ${cfg.keydbDataDir} 0755 root root - -"
  ];
}
