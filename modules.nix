{ ... }: {
  imports = [
    ./dashboard/virtualhost.nix

    ./dbs/minio-virtualhosts.nix
    ./dbs/obsidian-minio-container.nix

    ./fileserver/copyparty.nix
    ./fileserver/virtualhost.nix

    ./finance-dashboard/backend.nix
    ./finance-dashboard/discord-service.nix
    ./finance-dashboard/sudoers-rules.nix
    ./finance-dashboard/virtualhost.nix

    ./hardware/nbfc.nix

    ./media/bazarr.nix
    ./media/jackett.nix
    ./media/media.nix
    ./media/media-users.nix
    ./media/plex.nix
    ./media/radarr.nix
    ./media/transmission.nix
    ./media/virtualhosts.nix

    ./networking/acme.nix
    ./networking/ahavi.nix
    ./networking/ddclient.nix
    ./networking/dnsmasq.nix
    ./networking/nginx.nix
    ./networking/tailscale.nix

    ./virtualisation/podman-config.nix
  ];
}
