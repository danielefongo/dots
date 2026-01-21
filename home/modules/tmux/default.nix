{
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
    (pkgs.dotScript "tmux_run_on_nvim" ./scripts/run_on_nvim.sh [ ])
    (pkgs.dotScript "tmux_window_name" ./scripts/window_name.sh [ ])
  ];

  xdg.configFile."tmux/tmux.conf".source = pkgs.outLink "tmux/tmux.conf";
}
