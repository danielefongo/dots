{ lib, ... }:

lib.homeOpts.module "desktop" { } (_: {
  imports = lib.modulesIn ./. ++ [
    (lib.homeOpts.bundle "desktop.x11" [
      "desktop.dunst"
      "desktop.flameshot"
      "desktop.i3"
      "desktop.picom"
      "desktop.polybar"
      "desktop.gammastep"
      "desktop.wallpaper"
      "desktop.xbindkeys"
      "desktop.xsettingsd"
      "desktop.picom"
    ])
    (lib.homeOpts.bundle "desktop.wayland" [
      "desktop.niri"
      "desktop.waybar"
      "desktop.gsettings"
      "desktop.gammastep"
      "desktop.wallpaper"
      "desktop.dunst"
      "desktop.swappy"
    ])
  ];
})
