{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    sassc
  ];

  home.file.".themes/gtk-theme".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/gtk";
}
