{
  inputs,
  pkgs,
}: let
  wrappers = inputs.wrapper-manager.lib {
    inherit pkgs;
    specialArgs = {inherit inputs;};
    modules = [
      ./alacritty.nix
      ./nushell
      ./hyprland
    ];
  };
  inherit (wrappers.config) build;
in
  build.packages // {all = build.toplevel;}
