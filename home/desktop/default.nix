{ lib, ... }:

lib.homeOpts.module "desktop" { } (_: {
  imports = lib.modulesIn ./. ++ [
    (lib.homeOpts.bundle "desktop.x11" [
      "desktop.dunst"
      "desktop.flameshot"
      "desktop.i3"
      "desktop.picom"
      "desktop.polybar"
      "desktop.redshift"
      "desktop.wallpaper"
      "desktop.xbindkeys"
      "desktop.xsettingsd"
    ])
  ];
})
