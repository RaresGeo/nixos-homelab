{ ... }: {
  imports = [
    ./dashboard/virtualhost.nix

    ./dbs

    ./fileserver

    ./finance-dashboard/backend.nix
    ./finance-dashboard/discord-service.nix
    ./finance-dashboard/sudoers-rules.nix
    ./finance-dashboard/virtualhost.nix

    ./media

    ./networking

    ./virtualisation
  ];
}
