{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		jdk
		vscode-extensions.redhat.java
	];
}
