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
lib.optionalModule "x11.rofi" { } (cfg: {
  home.packages = with pkgs; [
    rofi
    (script-gen "rofi-theme" ./scripts/theme.sh)
  ];

  xdg.configFile."rofi".source = lib.outLink "rofi/config";
})
