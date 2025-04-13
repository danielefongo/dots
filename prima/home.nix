{ pkgs, prima-nix, ... }:

{
  imports = [ prima-nix.homeManagerModules.gitleaks ];

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
}
