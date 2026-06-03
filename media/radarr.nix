{config, ...}:

let
	media = config.media.users;
in
{
	imports = [ ./media.nix ];

	services.radarr = {
		enable = true;
		user = media.primary;
		group = media.group;
  };
}

