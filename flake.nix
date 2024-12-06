{
  description = "My NixOS system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      # WM's nixpkgs is only used for tests, you can safely drop this if needed.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    allSystems = nixpkgs: output:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: output nixpkgs.legacyPackages.${system});
    mapHost = hostname: {system}: let
      pkgs = nixpkgs.legacyPackages.${system};
      wrapped = (import ./wrapped) {
        inherit inputs pkgs;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs wrapped hostname;};
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
