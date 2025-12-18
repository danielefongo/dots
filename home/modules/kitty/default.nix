{ lib, pkgs, ... }:

lib.optionalModule "apps.kitty" { } (cfg: {
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty".source = lib.outLink "kitty";
})
