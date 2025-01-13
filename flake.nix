{
  description = "My NixOS system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs2.url = "nixpkgs/nixos-unstable";

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      # WM's nixpkgs is only used for tests, you can safely drop this if needed.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs2,
    ...
  }: let
    allSystems = nixpkgsN: output:
      nixpkgs2.lib.genAttrs nixpkgs2.lib.systems.flakeExposed
      (system: output nixpkgsN.legacyPackages.${system});
    mapHost = hostname: {system}: let
      pkgs1 = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs2 = import nixpkgs2 {
        inherit system;
        config.allowUnfree = true;
      };
      wrapped = (import ./wrapped) {
        inherit inputs pkgs2;
      };
    in
      nixpkgs2.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs wrapped hostname pkgs1 pkgs2;};
        modules = [
          ./configuration.nix
          ./hardware/${hostname}.nix
        ];
      };
    hosts = import ./hosts.nix;
  in {
    nixosConfigurations = builtins.mapAttrs mapHost hosts;
    formatter = allSystems nixpkgs2 (pkgs: pkgs.alejandra);
  };
}
