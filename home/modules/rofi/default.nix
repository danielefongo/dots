{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    (lib.dotScript "rofi-theme" ./scripts/theme.sh [ ])
    (lib.dotScript "rofi-otp" ./scripts/otp.sh [
      libnotify
      yubikey-manager
      xdotool
    ])
  ];

  xdg.configFile."rofi".source = lib.outLink "rofi/config";
}
