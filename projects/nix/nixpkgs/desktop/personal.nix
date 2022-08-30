{ config, lib, pkgs, ... }:

{
	nixpkgs.config.allowUnfreePredicate = (pkg: true);

	home.packages = with pkgs; [
		brave
		firefox
		keepassxc
		discord-ptb
		spotify
	];
}
