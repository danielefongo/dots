{ pkgs, ... }:

{
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
    (pkgs.dot.script "tmux_run_on_nvim" ./scripts/run_on_nvim.sh [ ])
    (pkgs.dot.script "tmux_window_name" ./scripts/window_name.sh [ ])
  ];

  xdg.configFile."tmux/tmux.conf".source = pkgs.dot.outLink "tmux/tmux.conf";
}
