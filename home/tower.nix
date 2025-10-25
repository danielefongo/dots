{
  user_data,
  ...
}:

{
  imports = [
    ./modules/alacritty
    ./modules/apps
    ./modules/btop
    ./modules/copyq
    ./modules/discord
    ./modules/docker
    ./modules/dunst
    ./modules/essentials
    ./modules/firefox
    ./modules/flameshot
    ./modules/fonts
    ./modules/fzf
    ./modules/git
    ./modules/gtk
    ./modules/i3
    ./modules/nix
    ./modules/nix-theme
    ./modules/nvim
    ./modules/picom
    ./modules/playerctl
    ./modules/plover
    ./modules/polybar
    ./modules/redshift
    ./modules/rofi
    ./modules/sesh
    ./modules/shell-utils
    ./modules/thunar
    ./modules/tig
    ./modules/tmux
    ./modules/wallpaper
    ./modules/webapps
    ./modules/xbindkeys
    ./modules/xsettingsd
    ./modules/zsh
  ];

  home.username = user_data.user;
  home.homeDirectory = user_data.home;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
