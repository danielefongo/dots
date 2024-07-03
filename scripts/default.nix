{ pkgs, config, dots_path, ... }:

let
  i3resize = pkgs.writeShellScriptBin "i3resize" (builtins.readFile ./i3resize);
  i3restart = pkgs.writeShellScriptBin "i3restart" (builtins.readFile ./i3restart);
in
{
  home.packages = [
    i3resize
    i3restart
  ];
}
