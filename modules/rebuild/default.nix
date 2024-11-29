{ pkgs, dots_path, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    case "$1" in
      -s)
        cd ${dots_path}
        sudo -E $(which nix) run github:numtide/system-manager -- switch --flake .
        ;;
      -h)
        cd ${dots_path}
        home-manager switch --flake .
        ;;
      *)
        cd ${dots_path}
        home-manager switch --flake .
        sudo -E $(which nix) run github:numtide/system-manager -- switch --flake .
        ;;
    esac
  '';
in
{
  home.packages = [
    nixRebuild
  ];
}
