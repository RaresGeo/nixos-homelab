{
  security.sudo.extraRules = [
    {
      users = [ "daniel" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl restart finance-backend.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart finance-discord.service";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
