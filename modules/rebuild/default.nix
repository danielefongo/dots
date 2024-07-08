{ pkgs, dots_path, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    cd ${dots_path}
    home-manager switch --flake .$1
  '';
in
{
  home.packages = [
    nixRebuild
  ];
}
