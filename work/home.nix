{
  pkgs,
  user_data,
  prima-nix,
  config,
  ...
}:

{
  imports = [
    ../home

    prima-nix.homeManagerModules.gitleaks
  ];

  targets.genericLinux.nixGL = {
    packages = pkgs.nixgl;
    defaultWrapper = "nvidia";
    installScripts = [
      "mesa"
      "nvidia"
    ];
  };

  module.apps.enable = true;
  module.cli.enable = true;
  module.desktop.enable = true;
  module.editor.enable = true;
  module.shell.enable = true;
  module.system.enable = true;
  module.terminal.enable = true;

  module.apps.discord.vesktop = false;
  module.apps.firefox.extraProfiles = {
    work = {
      id = 1;
      isDefault = true;
      addons = with pkgs.firefox-addons; [
        onepassword-password-manager
        refined-github
        tabliss
        ublock-origin
        vimium
        videospeed
        libredirect
        grammarly
        yet-another-smooth-scrolling
      ];
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      i3 = config.lib.nixGL.wrap prev.i3;
      picom = config.lib.nixGL.wrap prev.picom;
      rofi = config.lib.nixGL.wrap prev.rofi;
      polybar = config.lib.nixGL.wrap prev.polybar;
      polybarFull = config.lib.nixGL.wrap prev.polybarFull;
      i3lock-color = config.lib.nixGL.wrap prev.i3lock-color;
      flameshot = config.lib.nixGL.wrap prev.flameshot;
      redshift = config.lib.nixGL.wrap prev.redshift;

      kitty = config.lib.nixGL.wrap prev.kitty;
      firefox = config.lib.nixGL.wrap prev.firefox;
      spotify = config.lib.nixGL.wrap prev.spotify;
      telegram-desktop = config.lib.nixGL.wrap prev.telegram-desktop;
      vesktop = config.lib.nixGL.wrap (pkgs.electronWithGPU prev.vesktop);
      wasistlos = config.lib.nixGL.wrap prev.wasistlos;
      slack = config.lib.nixGL.wrap (pkgs.electronWithGPU prev.slack);
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
    kubectx
    krew
    kubelogin-oidc
    amazon-ecr-credential-helper
    suite_py
    vault
  ];

  nix.package = pkgs.nix;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/slack" = "slack.desktop";
    };
  };

  prima.gitleaks.enable = true;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
