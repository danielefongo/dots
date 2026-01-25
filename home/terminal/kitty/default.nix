{ pkgs, ... }:

{
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = pkgs.dot.outLink "kitty";
}
