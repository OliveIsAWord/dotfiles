{ pkgs, lib, inputs, ... }:
{
  wrappers.alacritty = {
    basePackage = pkgs.alacritty;
    flags = [ "--title" "meow!!!" ];
  };
}
