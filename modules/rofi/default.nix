{ pkgs, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/rofi";
}
