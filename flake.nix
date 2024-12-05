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
    inherit (nixpkgs) lib;
    mySystem = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${mySystem};
  in {
    nixosConfigurations = {
      thresholde = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          wrappers = self.packages.${mySystem};
          hostname = "thresholde";
        };
        system = mySystem;
        modules = [
          ./configuration.nix
          ./hardware/thresholde.nix
        ];
      };
      vespera = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          wrappers = self.packages.${mySystem};
          hostname = "vespera";
        };
        system = mySystem;
        modules = [
          ./configuration.nix
          ./hardware/vespera.nix
        ];
      };
    };

    packages.${mySystem} = (import ./wrapped) {
      inherit inputs pkgs;
    };

    formatter.${mySystem} = pkgs.alejandra;
  };
}
