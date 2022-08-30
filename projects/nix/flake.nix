{
	description = "Home Manager configuration flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = inputs @ { flake-utils, nixpkgs, home-manager, ... }:
	inputs.flake-utils.lib.eachDefaultSystem(system:
		let
			pkgs = inputs.nixpkgs.legacyPackages.${system};
		in { }
	) // {
		homeConfigurations.nix = inputs.home-manager.lib.homeManagerConfiguration {
			pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

			modules = [
			  ./home-manager/users/test/user.nix
			];
		};
	};
}
