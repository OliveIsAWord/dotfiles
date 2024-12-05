{
  pkgs,
  lib,
  ...
}: {
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    flags = ["--config" ./config.nu "--env-config" ./env.nu];
    env.STARSHIP_CONFIX = {
    force = true;
    value = ./starship.toml; };
    pathAdd = [
        pkgs.starship
	pkgs.carapace
    ];
  };
}
