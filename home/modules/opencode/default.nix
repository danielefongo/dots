{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.unstable.opencode ];

  xdg.configFile."opencode/config.json".source = lib.outLink "opencode/config.json";
}
