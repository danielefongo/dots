{
  pkgs,
  user,
  prima-nix,
  config,
  ...
}:

{
  imports = [
    ../mod/home

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

  mod.home.apps.audio.enable = true;
  mod.home.apps.discord = {
    enable = true;
    vesktop = false;
  };
  mod.home.apps.firefox = {
    enable = true;
    extraProfiles = {
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
  };
  mod.home.apps.ocr.enable = true;
  mod.home.apps.onepassword.enable = true;
  mod.home.apps.peek.enable = true;
  mod.home.apps.qalculate.enable = true;
  mod.home.apps.spotify.enable = true;
  mod.home.apps.thunar.enable = true;
  mod.home.apps.xnviewmp.enable = true;

  mod.home.cli.enable = true;

  mod.home.desktop.x11.enable = true;
  mod.home.desktop.rofi.enable = true;

  mod.home.editor.enable = true;
  mod.home.shell.enable = true;
  mod.home.system.enable = true;
  mod.home.terminal.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      i3 = config.lib.nixGL.wrap prev.i3;
      picom = config.lib.nixGL.wrap prev.picom;
      rofi = config.lib.nixGL.wrap prev.rofi;
      polybar = config.lib.nixGL.wrap prev.polybar;
      polybarFull = config.lib.nixGL.wrap prev.polybarFull;
      i3lock-color = config.lib.nixGL.wrap prev.i3lock-color;
      flameshot = config.lib.nixGL.wrap prev.flameshot;
      gammastep = config.lib.nixGL.wrap prev.gammastep;

      kitty = config.lib.nixGL.wrap prev.kitty;
      firefox = config.lib.nixGL.wrap prev.firefox;
      spotify = config.lib.nixGL.wrap prev.spotify;
      telegram-desktop = config.lib.nixGL.wrap prev.telegram-desktop;
      vesktop = config.lib.nixGL.wrap (pkgs.electronWithGPU prev.vesktop);
      wasistlos = config.lib.nixGL.wrap prev.wasistlos;
      slack = config.lib.nixGL.wrap (pkgs.electronWithGPU prev.slack);
    })
  ];

  home.username = user.name;
  home.homeDirectory = user.home;
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
