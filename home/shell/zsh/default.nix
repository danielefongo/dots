{ lib, pkgs, ... }:

lib.homeOpts.module "shell.zsh" { } (_: {
  home.packages = with pkgs; [
    zsh
    sheldon
    ruby # for scm_breeze
  ];

  home.file.".zshrc".source = pkgs.dot.outLink "zsh/zshrc";
  xdg.configFile."sheldon".source = pkgs.dot.outLink "sheldon";

  mod.home.shell.fzf.enable = true;
  mod.home.cli.direnv.enable = true;
  mod.home.cli.zoxide.enable = true;
  mod.home.cli.git.enable = true;
  mod.home.terminal.tmux.enable = true;
})
