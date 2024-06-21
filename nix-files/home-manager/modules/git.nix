{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    git
    delta
    tig
  ];
}
