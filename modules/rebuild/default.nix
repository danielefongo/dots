{ pkgs, dots_path, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    cd ${dots_path}
    home-manager switch --flake .$1
  '';

  nixRebuildSystem = pkgs.writeShellScriptBin "nix-rebuild-system" ''
    cd ${dots_path}
    sudo -E $(which nix) run github:numtide/system-manager -- switch --flake .
  '';
in
{
  home.packages = [
    nixRebuild
    nixRebuildSystem
  ];
}
