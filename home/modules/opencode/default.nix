{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.unstable.opencode ];

  xdg.configFile."opencode/config.json".source = pkgs.outLink "opencode/config.json";
}
