{ pkgs, ... }:

{
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = pkgs.dot.outLink "tig";
}
