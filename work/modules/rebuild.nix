{ pkgs, user_data, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    DOTS_PATH=${user_data.dots_path}

    cd $DOTS_PATH/work
    case "$1" in
      -s)
        sudo -E $(which nix) run github:numtide/system-manager -- switch --flake .
        ;;
      -h)
        home-manager switch --flake .
        ;;
      *)
        home-manager switch --flake .
        sudo -E $(which nix) run github:numtide/system-manager -- switch --flake .
        ;;
    esac
  '';
in
{
  home.packages = [ nixRebuild ];
}
