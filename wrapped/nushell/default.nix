{
  pkgs,
  lib,
  ...
}: let
  configSource = lib.strings.concatStrings (map builtins.readFile [./config.nu ./starship.nu ./zoxide.nu]);
  configFile = pkgs.writeText "config.nu" configSource;
in {
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    flags = ["--config" "${configFile}" "--env-config" ./env.nu];
  };
}
