{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    sheldon
    ruby # for scm_breeze
  ];

  home.file.".zshrc".source = pkgs.outLink "zsh/zshrc";
  xdg.configFile."sheldon".source = pkgs.outLink "sheldon";
}
