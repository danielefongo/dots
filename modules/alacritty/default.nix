{ lib, pkgs, dots_path, config, ... }:

{
  home.packages = [
    (lib.wrapNixGL pkgs.alacritty)
  ];

  xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/alacritty";
}
