{ ... }: {
  imports = [
    ./registry.nix
    ./podman-config.nix
  ];

  config.virtualisation.oci-containers.backend = "podman";
}
