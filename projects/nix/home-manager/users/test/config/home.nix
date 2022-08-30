{ config, lib, pkgs, ... }:

{
	home.username = "nix";
	home.homeDirectory = "/home/nix";
	
	home.stateVersion = "22.05";
}
