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
    wrapped = (import ./wrapped) {
      inherit inputs pkgs;
    };
  in {
    nixosConfigurations = {
      thresholde = lib.nixosSystem {
        specialArgs = {
          inherit inputs wrapped;
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
          inherit inputs wrapped;
          hostname = "vespera";
        };
        system = mySystem;
        modules = [
          ./configuration.nix
          ./hardware/vespera.nix
        ];
      };
    };

    formatter.${mySystem} = pkgs.alejandra;
  };
}
