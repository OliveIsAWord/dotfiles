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

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      mySystem = "x86_64-linux";
    in {
    nixosConfigurations = {
      vespera = lib.nixosSystem {
        specialArgs = { inherit inputs; wrappers = self.packages.${mySystem}; };
        system = mySystem;
        modules = [
          ./configuration.nix
          # ./wrapped
        ];
      };
    };
    
    packages.${mySystem} = (inputs.wrapper-manager.lib {
      pkgs = nixpkgs.legacyPackages.${mySystem};
      specialArgs = { inherit inputs; };
      modules = [
        ./wrapped/alacritty.nix
        ./wrapped/nushell
      ];
    }).config.build.packages;
  };
}
