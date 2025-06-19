{ pkgs, dots_path, ... }:

let
  nixRebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    DOTS_PATH=${dots_path}

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

    path="$(nix profile list | grep 'store' | grep 'home-manager-path' | awk '{print $3}')/bin"

    if [ -d "$path" ]; then
      ls -la "$path" | awk '{if ($11 != "") print $11}' | sed 's|/bin/.*||' | cut -d'-' -f2- | sort | uniq >$DOTS_PATH/home-pkgs-versions.txt
    fi
  '';
in
{
  home.packages = [ nixRebuild ];
}
