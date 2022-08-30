{ config, lib, pkgs, ... }:

{
	nixpkgs.config.allowUnfreePredicate = (pkg: true);

	home.packages = with pkgs; [
		github-desktop
		vscode
		vscode-extensions.oderwat.indent-rainbow
	];
	
	home.activation = {
		linkVSCodeExtensions = {
			after = [ "writeBoundary" "createXdgUserDirectories" ];
			before = [ ];
			data = ''
				rm -rf ~/.vscode/extensions
				mkdir -p ~/.vscode/extensions
				ln -sf ${config.home.homeDirectory}/.nix-profile/share/vscode/extensions/* ~/.vscode/extensions
			'';
		};
	};
}
