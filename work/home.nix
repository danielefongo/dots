{
  pkgs,
  user_data,
  prima-nix,
  nixgl,
  config,
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

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  nixpkgs.overlays = [
    (final: prev: {
      alacritty = config.lib.nixGL.wrap prev.alacritty;
      telegram-desktop = config.lib.nixGL.wrap prev.telegram-desktop;
      whatsapp-for-linux = config.lib.nixGL.wrap prev.whatsapp-for-linux;
      picom = config.lib.nixGL.wrap prev.picom;
      vesktop = config.lib.nixGL.wrap prev.vesktop;
      firefox = config.lib.nixGL.wrap prev.firefox;
    })
  ];

  home.username = user_data.user;
  home.homeDirectory = user_data.home;
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
