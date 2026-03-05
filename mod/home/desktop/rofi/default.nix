{
  config,
  lib,
  pkgs,
  ...
}:

let
  isWayland = lib.hasHomeModule config "desktop.wayland";
in
lib.homeOpts.module "desktop.rofi" { } (_: {
  home.packages = with pkgs; [
    rofi
    (pkgs.dot.script "rofi-theme" ./scripts/theme.sh [ ])
    (pkgs.dot.script "rofi-otp" ./scripts/otp.sh [
      libnotify
      yubikey-manager
      (type-text isWayland)
    ])
    (pkgs.dot.script "rofi-power" ./scripts/power.sh [ systemd ])
  ];

  xdg.configFile."rofi".source = pkgs.dot.outLink "rofi/config";

  mod.home.cli.yubikey.enable = true;
  mod.home.system.theme.enable = true;
})
