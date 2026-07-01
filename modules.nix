{ ... }: {
  imports = [
    ./dashboard/virtualhost.nix

    ./dbs

    ./fileserver

    ./finance-dashboard

    ./media

    ./networking

    ./virtualisation
  ];
}
