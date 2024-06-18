{
  pkgs,
  lib,
  inputs,
  ...
}: {
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    flags = ["--config" ./config.nu "--env-config" ./env.nu "--no-history"];
  };
}
