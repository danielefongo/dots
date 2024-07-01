{ pkgs, dots_path, config, home, ... }:

{
  home.packages = with pkgs; [
    curl
    zsh
    fzf
    ripgrep
    autojump
    tmux
    btop
    less
  ];

  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/.zshrc";
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/tmux/tmux.conf";
  home.file.".lesskey".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/.lesskey";
  xdg.configFile."btop".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/btop";
}
