{ config, lib, pkgs, ... }:

{
	nixpkgs.config.allowUnfreePredicate = (pkg: true);

	home.packages = with pkgs; [
		blender
		davinci-resolve
		obs-studio
	];
}
