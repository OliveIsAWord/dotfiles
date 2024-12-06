{
  inputs,
  pkgs1,
  pkgs2,
}: let
  wrappers = inputs.wrapper-manager.lib {
    pkgs = pkgs1;
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
