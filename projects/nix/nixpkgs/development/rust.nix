{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		rustup
		vscode-extensions.matklad.rust-analyzer
	];
}
