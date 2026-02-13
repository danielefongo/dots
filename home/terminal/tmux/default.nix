{ lib, pkgs, ... }:

lib.opts.module "terminal.tmux" { } (_: {
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
    (pkgs.dot.script "tmux_run_on_nvim" ./scripts/run_on_nvim.sh [ ])
    (pkgs.dot.script "tmux_window_name" ./scripts/window_name.sh [ ])
    (pkgs.dot.script "tmux_join" ./scripts/join_pane.sh [ pkgs.fzf ])
    (pkgs.dot.script "tmux_send" ./scripts/send_pane.sh [ pkgs.fzf ])
  ];

  xdg.configFile."tmux/tmux.conf".source = pkgs.dot.outLink "tmux/tmux.conf";
})
