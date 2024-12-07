{
  inputs,
  pkgs2,
}: let
  wrappers = inputs.wrapper-manager.lib {
    pkgs = pkgs2;
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
