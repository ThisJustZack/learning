{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		python3Minimal
		vscode-extensions.ms-python.python
	];
}
