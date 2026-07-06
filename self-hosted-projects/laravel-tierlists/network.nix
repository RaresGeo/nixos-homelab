{ config, ... }:
let
  podman = config.virtualisation.podman.package;
in
{
  systemd.services.podman-network-laravel-tierlist = {
    description = "Create podman network for laravel-tierlist";
    after = [ "podman.service" ];
    requires = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/sh -c '${podman}/bin/podman network create laravel-tierlist || true'";
    };
  };
}
