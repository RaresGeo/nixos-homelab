{ config, pkgs, ... }:

let
  cfg = config.services.homerok;
  # distroless "nonroot"
  containerUid = "65532";
in
{
  virtualisation.oci-containers.containers.homerok-server = {
    image = cfg.image;
    pull = "newer";
    autoStart = true;

    environment = {
      HOMEROK_DOMAIN = cfg.host;
      HOMEROK_LISTEN = ":4500";
      HOMEROK_TOKENS_FILE = "/run/secrets/homerok-tokens";
    };
    ports = [ "127.0.0.1:${toString cfg.port}:4500" ];
    # The directory, not the file: the copy below is replaced atomically, and
    # a bind-mounted file would keep pointing at the old inode
    volumes = [ "/run/homerok:/run/secrets:ro" ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };

  # The secrets file stays root-only; the container gets its own copy, kept
  # in sync on every edit so tokens rotate without a restart.
  systemd.services.homerok-tokens = {
    description = "Copy homerok tokens where the container can read them";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.coreutils}/bin/install -d -m 0755 /run/homerok
      ${pkgs.coreutils}/bin/install -m 0400 -o ${containerUid} -g ${containerUid} \
        ${cfg.tokensFile} /run/homerok/.homerok-tokens.tmp
      ${pkgs.coreutils}/bin/mv -f /run/homerok/.homerok-tokens.tmp /run/homerok/homerok-tokens
    '';
  };

  systemd.paths.homerok-tokens = {
    description = "Watch the homerok tokens file";
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = cfg.tokensFile;
  };

  systemd.services.podman-homerok-server = {
    after = [ "homerok-tokens.service" ];
    requires = [ "homerok-tokens.service" ];
  };
}
