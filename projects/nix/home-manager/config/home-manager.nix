{ config, lib, pkgs, ... }:

{	
	programs.home-manager.enable = true;
	
	home.activation = {
		linkDesktopApplications = {
			after = [ "writeBoundary" "createXdgUserDirectories" ];
			before = [ ];
			data = ''
				rm -rf ${config.xdg.dataHome}/applications/home-manager
				mkdir -p ${config.xdg.dataHome}/applications/home-manager
				ln -sf ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/applications/home-manager/
			'';
		};
	};
}
