{ pkgs, dots_path, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    DOTS_PATH=${dots_path}

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

    path="$(nix profile list | grep 'store' | grep 'home-manager-path' | awk '{print $3}')/bin"

    if [ -d "$path" ]; then
      ls -la "$path" | awk '{if ($11 != "") print $11}' | sed 's|/bin/.*||' | cut -d'-' -f2- | sort | uniq >$DOTS_PATH/home-pkgs-versions.txt
    fi
  '';
in
{
  home.packages = [ nixRebuild ];
}
