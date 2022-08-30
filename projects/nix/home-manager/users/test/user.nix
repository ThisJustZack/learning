{ config, lib, pkgs, ... }:

{
	imports = [
		../../config/home-manager.nix
		./config/home.nix
		./config/nixpkgs.nix		
	];
}
