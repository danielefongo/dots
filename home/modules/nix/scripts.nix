{ pkgs, user_data, ... }:

let
  nix-check = pkgs.writeShellScriptBin "nix-check" ''
    #!${pkgs.runtimeShell}
    set -euo pipefail

    DOTS_PATH="${user_data.dots_path}"
    USER="${user_data.user}"

    if [ "$#" -lt 1 ]; then
      echo "Usage: nix-check [tower|work]"
      exit 1
    fi

    check_tower() {
      echo "🔎 Checking tower system..."
      nix build "$DOTS_PATH/#nixosConfigurations.tower.config.system.build.toplevel" --out-link "$DOTS_PATH/build/tower"
    }

    check_work() {
      echo "🔎 Checking work home and system configs..."
      nix build "$DOTS_PATH/work#homeConfigurations.$USER.activationPackage.outPath" --out-link "$DOTS_PATH/build/work/home"
      nix build "$DOTS_PATH/work#systemConfigs.default" --out-link "$DOTS_PATH/build/work/system"
    }

    case "$1" in
      tower)
        check_tower;;
      work)
        check_work;;
      all)
        check_tower && check_work;;
    esac
  '';
in
{
  home.packages = [
    nix-check
  ];
}
