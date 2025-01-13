{pkgs, ...}: {
  wrappers.alacritty = {
    basePackage = pkgs.alacritty;
    flags = ["-o=font.size=9" "-o=window.opacity=0.6" "--command=nu"];
  };
}
