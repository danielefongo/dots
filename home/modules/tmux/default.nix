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
    (lib.dotScript "tmux_run_on_nvim" ./scripts/run_on_nvim.sh [ ])
    (lib.dotScript "tmux_window_name" ./scripts/window_name.sh [ ])
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
