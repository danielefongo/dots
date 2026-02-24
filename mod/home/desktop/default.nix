{ lib, ... }:

lib.homeOpts.module "desktop" { } (_: {
  imports = lib.modulesIn ./. ++ [
    (lib.homeOpts.bundle "desktop.x11" [
      "desktop.dunst"
      "desktop.flameshot"
      "desktop.gammastep"
      "desktop.i3"
      "desktop.picom"
      "desktop.picom"
      "desktop.polybar"
      "desktop.wallpaper"
      "desktop.xbindkeys"
      "desktop.xsettingsd"
    ])
    (lib.homeOpts.bundle "desktop.wayland" [
      "desktop.dunst"
      "desktop.flameshot"
      "desktop.gammastep"
      "desktop.gsettings"
      "desktop.niri"
      "desktop.wallpaper"
      "desktop.waybar"
    ])
  ];
})
