{ pkgs, lib, inputs, ... }:
{
  wrappers.nushell = {
    basePackage = pkgs.nushell;
    flags = [ "--no-config-file" ];
  };
}
