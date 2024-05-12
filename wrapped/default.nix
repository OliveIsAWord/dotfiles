{ config, lib, inputs, pkgs, ... }: {

users.users.olive.packages = [
  (inputs.wrapper-manager.lib.build {
    inherit pkgs;
    specialArgs = { inherit inputs; };
    modules = [
      ./alacritty.nix
      ./nushell.nix
    ];
  })
];

}
