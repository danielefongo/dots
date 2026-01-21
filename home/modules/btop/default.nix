{ pkgs, ... }:

{
  home.packages = with pkgs; [ btop ];

  xdg.configFile."btop".source = pkgs.dot.outLink "btop";
}
