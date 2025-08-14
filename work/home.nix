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
    ../home/modules/alacritty
    ../home/modules/apps
    ../home/modules/btop
    ../home/modules/discord
    ../home/modules/docker
    ../home/modules/dunst
    ../home/modules/essentials
    ../home/modules/flameshot
    ../home/modules/fonts
    ../home/modules/fzf
    ../home/modules/git
    ../home/modules/gtk
    ../home/modules/i3
    ../home/modules/nix
    ../home/modules/nvim
    ../home/modules/picom
    ../home/modules/playerctl
    ../home/modules/plover
    ../home/modules/polybar
    ../home/modules/redshift
    ../home/modules/rofi
    ../home/modules/sesh
    ../home/modules/shell-utils
    ../home/modules/tig
    ../home/modules/tmux
    ../home/modules/wallpaper
    ../home/modules/webapps
    ../home/modules/xbindkeys
    ../home/modules/xsettingsd
    ../home/modules/zsh

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
    slack
    awscli2
    bruno
    cloudflared
    jetbrains.datagrip
    insomnia
    cloudflare-warp
    k9s
    kubectl
    krew
    suite_py
    vault
    codescene-cli
    nix-theme
  ];

  systemd.user.services = {
    theme = {
      Unit = {
        Description = "Theme";
      };

      Service = {
        ExecStart = "${pkgs.writeShellScript "nix-theme-runner" ''
          #!/bin/bash

          while true; do
            ${pkgs.nix-theme}/bin/nix-theme
            sleep 2
          done
        ''}";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };

  prima.gitleaks.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
