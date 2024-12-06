{
  pkgs,
  lib,
  ...
}: let
  hotConfigged = [
    "hypridle"
    "hyprlock"
    "hyprpaper"
    "hyprpicker"
    "hyprshot"
  ];
  hyprlandWrapped = {hyprland = {basePackage = pkgs.hyprland.override {enableXWayland = true;};};};
  mapHot = pkgName: {basePackage = pkgs.${pkgName};};
  createAttrSet = f: keys:
    builtins.listToAttrs (map (k: {
        name = k;
        value = f k;
      })
      keys);
in {
  wrappers = createAttrSet mapHot hotConfigged // hyprlandWrapped;
}
