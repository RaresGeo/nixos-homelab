{ pkgs, ... }:

{
  systemd.services.podman-auto-update = {
    description = "Update podman containers to their latest registry images";
    documentation = [ "man:podman-auto-update(1)" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman auto-update";
      ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
    };
  };
}
