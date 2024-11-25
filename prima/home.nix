{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli2
    cloudflare-warp
    k9s
    kubectl
    suite_py
  ];
}
