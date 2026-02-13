{ lib, pkgs, ... }:

lib.opts.module "shell.zsh" { } (_: {
  home.packages = with pkgs; [
    zsh
    sheldon
    ruby # for scm_breeze
  ];

  home.file.".zshrc".source = pkgs.dot.outLink "zsh/zshrc";
  xdg.configFile."sheldon".source = pkgs.dot.outLink "sheldon";

  module.shell.fzf.enable = true;
  module.cli.direnv.enable = true;
  module.cli.zoxide.enable = true;
  module.cli.git.enable = true;
  module.terminal.tmux.enable = true;
})
