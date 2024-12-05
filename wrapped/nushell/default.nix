{
  pkgs,
  lib,
  ...
}: {
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    flags = ["--config" ./config.nu "--env-config" ./env.nu];
    env.STARSHIP_CONFIG = {
      force = true;
      value = ./starship.toml;
    };
    pathAdd = [
      pkgs.starship
      pkgs.carapace
    ];
  };
}
