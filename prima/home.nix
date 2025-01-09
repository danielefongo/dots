{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli2
    bruno
    dbeaver-bin
    insomnia
    cloudflare-warp
    k9s
    kubectl
    suite_py
  ];
}
