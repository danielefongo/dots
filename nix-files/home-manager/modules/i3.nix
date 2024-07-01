{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    i3
    i3lock-fancy-rapid
    rofi
    flameshot
  ];

  xdg.configFile."i3".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/i3";
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/rofi";
}
