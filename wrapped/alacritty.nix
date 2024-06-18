{
  pkgs,
  lib,
  inputs,
  ...
}: {
  wrappers.alacritty = {
    basePackage = pkgs.alacritty;
    flags = ["-o=font.size=9" "--command=nu"];
  };
}
