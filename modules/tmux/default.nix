{ pkgs, dots_path, config, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/tmux/tmux.conf";
}
