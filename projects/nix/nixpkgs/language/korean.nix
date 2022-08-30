{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		kime
		vscode-extensions.ms-ceintl.vscode-language-pack-ko
		baekmuk-ttf
		nanum
	];
}
