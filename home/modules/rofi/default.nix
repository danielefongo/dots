{
  lib,
  user_data,
  pkgs,
  ...
}:

let
  script-gen =
    name: file:
    pkgs.writeShellScriptBin name ''
      #!${pkgs.runtimeShell}
      DOTS_PATH="${user_data.dots_path}"
      USER="${user_data.user}"
      ${builtins.readFile file}
    '';
in
{
  home.packages = with pkgs; [
    libnotify
    rofi
    xdotool
    (script-gen "rofi-theme" ./scripts/theme.sh)
    (script-gen "rofi-otp" ./scripts/otp.sh)
  ];

  xdg.configFile."rofi".source = lib.outLink "rofi/config";
}
