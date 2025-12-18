{ lib, pkgs, ... }:

lib.optionalModule "shell.zsh" { } (cfg: {
  home.packages = with pkgs; [
    zsh
    sheldon
    ruby # for scm_breeze
  ];

  home.file.".zshrc".source = lib.outLink "zsh/zshrc";
  xdg.configFile."sheldon".source = lib.outLink "sheldon";

  module.shell.fzf.enable = true;
})
