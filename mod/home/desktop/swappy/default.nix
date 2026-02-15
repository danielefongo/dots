{
  lib,
  pkgs,
  ...
}:

let
  waylandScreenshot = pkgs.writeShellScriptBin "screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
  '';
in
lib.homeOpts.module "desktop.swappy" { } (_: {
  home.packages = [
    waylandScreenshot
  ];
})
