{ config, lib, pkgs, ... }:

{
	imports = [
		../../../../nixpkgs/desktop/personal.nix
		../../../../nixpkgs/desktop/developer.nix
		../../../../nixpkgs/development/rust.nix
	];
}
