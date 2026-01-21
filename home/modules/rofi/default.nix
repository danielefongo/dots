{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    (pkgs.dotScript "rofi-theme" ./scripts/theme.sh [ ])
    (pkgs.dotScript "rofi-otp" ./scripts/otp.sh [
      libnotify
      yubikey-manager
      xdotool
    ])
  ];

  xdg.configFile."rofi".source = pkgs.outLink "rofi/config";
}
