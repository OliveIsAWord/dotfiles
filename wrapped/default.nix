{
  inputs,
  pkgs,
}: let
  x = {
    inherit pkgs;
    specialArgs = {inherit inputs;};
    modules = [
      ./alacritty.nix
      ./nushell
    ];
  };
  wrappers = (inputs.wrapper-manager.lib x).config.build;
in
  wrappers.packages // {all = wrappers.toplevel;}
