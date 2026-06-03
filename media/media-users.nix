{ config, lib, ... }:

let
	cfg = config.media.users;
in {
	options.media.users = {
		primary = lib.mkOption {
			type = lib.types.str;
			default = "daniel";
			description = "Primary user for media services";
		};
		group = lib.mkOption {
			type = lib.types.str;
			default = "media";
			description = "Shared group for media access";
		};
	};

	config = {
		users.users.${cfg.primary}.extraGroups = [ cfg.group ];

		users.groups.${cfg.group} = {
			members = [ cfg.primary ];
		};
	};
}

