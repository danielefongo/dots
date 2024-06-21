{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    i3
    i3lock-fancy-rapid
    rofi
    flameshot
    feh
  ];
}
