{ pkgs, ... }: {
wrappers.bash = {
  basePackage = pkgs.bash;
  flags = [ "--rcfile" ./bashrc ];
};
}