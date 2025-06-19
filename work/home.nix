{
  pkgs,
  user,
  prima-nix,
  home,
  ...
}:

{
  imports = [
    ../modules/alacritty
    ../modules/apps
    ../modules/btop
    ../modules/discord
    ../modules/docker
    ../modules/dunst
    ../modules/essentials
    ../modules/flameshot
    ../modules/fonts
    ../modules/fzf
    ../modules/git
    ../modules/gtk
    ../modules/i3
    ../modules/nix
    ../modules/nvim
    ../modules/picom
    ../modules/playerctl
    ../modules/plover
    ../modules/polybar
    ../modules/redshift
    ../modules/rofi
    ../modules/sesh
    ../modules/shell-utils
    ../modules/theme
    ../modules/tig
    ../modules/tmux
    ../modules/wallpaper
    ../modules/webapps
    ../modules/xbindkeys
    ../modules/xsettingsd
    ../modules/zsh

    ./modules/firefox.nix
    ./modules/rebuild.nix
    prima-nix.homeManagerModules.gitleaks
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = with pkgs; [
    awscli2
    bruno
    cloudflared
    dbeaver-bin
    insomnia
    cloudflare-warp
    k9s
    kubectl
    krew
    suite_py
    vault
    codescene-cli
  ];

  prima.gitleaks.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
