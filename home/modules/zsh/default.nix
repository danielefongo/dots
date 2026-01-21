{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    sheldon
    ruby # for scm_breeze
  ];

  home.file.".zshrc".source = pkgs.dot.outLink "zsh/zshrc";
  xdg.configFile."sheldon".source = pkgs.dot.outLink "sheldon";
}
