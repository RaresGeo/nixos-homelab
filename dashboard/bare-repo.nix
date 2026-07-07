{ config, pkgs, ... }:

let
  cfg = config.services.dashboard;

  # Checks out the pushed branch into the web root on receive
  postReceiveHook = pkgs.writeShellScript "dashboard-post-receive" ''
    while read oldrev newrev refname; do
      branch=$(basename "$refname")
      echo "Pushed $branch (old: $oldrev -> new: $newrev)" >&2

      if [ "$branch" = "${cfg.branch}" ]; then
        ${pkgs.git}/bin/git --work-tree=${cfg.stateDir} --git-dir=${cfg.bareRepoDir} checkout -f ${cfg.branch}
        echo "Dashboard deployed to ${cfg.stateDir}" >&2
      fi
    done
  '';
in
{
  systemd.tmpfiles.rules = [
    "d ${cfg.bareRepoDir} 0755 ${cfg.pushUser} users - -"
    "d ${cfg.bareRepoDir}/hooks 0755 ${cfg.pushUser} users - -"
    "d ${cfg.stateDir} 0755 ${cfg.pushUser} users - -"
    "L+ ${cfg.bareRepoDir}/hooks/post-receive - - - - ${postReceiveHook}"
  ];

  # Idempotently init the bare repo so pushes have somewhere to land
  systemd.services.dashboard-bare-repo = {
    description = "Initialize the dashboard bare git repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    path = [ pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = cfg.pushUser;
    };
    script = ''
      if [ ! -e ${cfg.bareRepoDir}/HEAD ]; then
        git init --bare --initial-branch=${cfg.branch} ${cfg.bareRepoDir}
      fi
    '';
  };
}
