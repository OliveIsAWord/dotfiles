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
    allSystems = nixpkgs: output:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: output nixpkgs.legacyPackages.${system});
    mapHost = hostname: {system}: let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs2 = nixpkgs2.legacyPackages.${system};
      wrapped = (import ./wrapped) {
        inherit inputs pkgs pkgs2;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs wrapped hostname pkgs2;};
        modules = [
          ./configuration.nix
          ./hardware/${hostname}.nix
        ];
      };
    hosts = import ./hosts.nix;
  in {
    nixosConfigurations = builtins.mapAttrs mapHost hosts;
    formatter = allSystems nixpkgs (pkgs: pkgs.alejandra);
  };
}
