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
    ../home/modules/default.nix

    prima-nix.homeManagerModules.gitleaks
  ];

  targets.genericLinux.nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      kitty = config.lib.nixGL.wrap prev.kitty;
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
    kubectx
    krew
    kubelogin-oidc
    amazon-ecr-credential-helper
    suite_py
    vault
  ];

  prima.gitleaks.enable = true;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  module = {
    apps.full.enable = true;
    apps.full.firefox.profiles = {
      personal = {
        isDefault = false;
        id = 0;
        addons = with pkgs.firefox-addons; [
          onepassword-password-manager
          refined-github
          tabliss
          ublock-origin
          vimium
          videospeed
          libredirect
          darkreader
          flagfox
          clearurls
        ];
      };

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
        ];
      };
    };
    nix.theme = {
      enable = true;
      polling = true;
    };
    shell.full.enable = true;
    i3.enable = true;
    virtualisation.docker.enable = true;
    others.playerctl.enable = true;
    others.tailscale.enable = true;
    terminal.full.enable = true;
  };

}
