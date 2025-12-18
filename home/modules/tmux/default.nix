{ lib, pkgs, ... }:

let
  run_on_nvim = (
    pkgs.writeShellScriptBin "tmux_run_on_nvim" (builtins.readFile ./scripts/run_on_nvim.sh)
  );
  tmux_window_name = (
    pkgs.writeShellScriptBin "tmux_window_name" (builtins.readFile ./scripts/window_name.sh)
  );
in
lib.optionalModule "terminal.tmux" { } (cfg: {
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
    run_on_nvim
    tmux_window_name
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
})
