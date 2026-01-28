{ lib, pkgs, ... }:

lib.opts.module "desktop.rofi" { } (cfg: {
  home.packages = with pkgs; [
    rofi
    (pkgs.dot.script "rofi-theme" ./scripts/theme.sh [ ])
    (pkgs.dot.script "rofi-otp" ./scripts/otp.sh [
      libnotify
      yubikey-manager
      xdotool
    ])
  ];

  xdg.configFile."rofi".source = pkgs.dot.outLink "rofi/config";

  module.cli.yubikey.enable = true;
  module.system.theme.enable = true;
})
