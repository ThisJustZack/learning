{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		go
		vscode-extensions.golang.go
	];
}
