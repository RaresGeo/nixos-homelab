{config, ...}:

let
	media = config.media.users;
in
{
  imports = [ ./media.nix ];

  services.transmission = {
    enable = true;
    user = media.primary;
    group = media.group;

    openRPCPort = true;

    settings = {
      download-dir = "/media/downloads";  
      incomplete-dir = "/media/incomplete";
      incomplete-dir-enabled = true;
      watch-dir = "/media/watch";  

      rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-whitelist-enabled = false; 
      rpc-whitelist = "127.0.0.1,192.168.100.50,nixos.local,nixos.*.ts.net";
      rpc-authentication-required = true;
      rpc-username = "daniel";
      rpc-password = "REDACTED";
    };
  };
}

