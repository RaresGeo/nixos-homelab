{ ... }: {
  imports = [
    ./registry.nix
    ./podman-config.nix
    ./auto-update.nix
  ];

  config.virtualisation.oci-containers.backend = "podman";
}
