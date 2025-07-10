{ lib, pkgs, ... }:

let
  run_on_nvim = (pkgs.writeShellScriptBin "run_on_nvim" (builtins.readFile ./run_on_nvim.sh));
in
{
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
    run_on_nvim
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
