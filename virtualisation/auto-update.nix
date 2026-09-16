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

  # Pull-based deploys: CI pushes images to the registry, this picks them up
  systemd.timers.podman-auto-update = {
    description = "Periodically update podman containers to their latest registry images";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
      Persistent = true;
    };
  };
}
