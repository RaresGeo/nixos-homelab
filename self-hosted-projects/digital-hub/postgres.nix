{ config, pkgs, ... }:

let
  cfg = config.services.digital-hub;
in
{
  virtualisation.oci-containers.containers.digital-hub-postgres = {
    image = cfg.postgresImage;
    environmentFiles = [ cfg.environmentFile ];
    volumes = [
      "${cfg.postgresDataDir}:/var/lib/postgresql/data"
    ];
    autoStart = true;
    extraOptions = [
      "--network=digital-hub"
      "--network-alias=postgres"
      "--health-cmd=pg_isready"
      "--health-interval=10s"
      "--health-timeout=5s"
      "--health-retries=5"
      "--health-start-period=30s"
    ];
  };

  systemd.services.podman-digital-hub-postgres = {
    after = [ "podman-network-digital-hub.service" ];
    requires = [ "podman-network-digital-hub.service" ];
  };

  # The postgres entrypoint chowns this to its own user on first start
  systemd.tmpfiles.rules = [
    "d ${cfg.postgresDataDir} 0700 root root - -"
  ];

  systemd.services.digital-hub-postgres-healthcheck = {
    description = "Wait for digital-hub postgres container to be healthy";
    after = [ "podman-digital-hub-postgres.service" ];
    requires = [ "podman-digital-hub-postgres.service" ];
    before = [ "podman-digital-hub-backend.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for i in $(seq 1 18); do
        status=$(${pkgs.podman}/bin/podman inspect --format '{{.State.Health.Status}}' digital-hub-postgres || echo "starting")
        if [ "$status" = "healthy" ]; then
          exit 0
        fi
        sleep 5
      done
      echo "digital-hub-postgres did not become healthy in time"
      exit 1
    '';
  };
}
