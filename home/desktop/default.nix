{ lib, ... }:

lib.opts.module "desktop" { } (cfg: {
  imports = lib.modulesIn ./. ++ [
    (lib.opts.bundle "desktop.x11" [
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
