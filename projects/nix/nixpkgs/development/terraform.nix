{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		terraform
		vscode-extensions.hashicorp.terraform
	];
}
