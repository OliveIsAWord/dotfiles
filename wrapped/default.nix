{inputs, pkgs}: let wrappers = (inputs.wrapper-manager.lib {
      inherit pkgs;
      specialArgs = { inherit inputs; };
      modules = [
        ./alacritty.nix
        ./nushell
      ];
    }).config.build;
    in
    wrappers.packages // { all = wrappers.toplevel; }
    
    