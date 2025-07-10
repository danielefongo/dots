{ pkgs, user_data, ... }:

let
  nix-check = pkgs.writeShellScriptBin "nix-check" ''
    #!${pkgs.runtimeShell}
    set -euo pipefail

    DOTS_PATH="${user_data.dots_path}"
    USER="${user_data.user}"

    check_tower() {
      echo "🔎 Checking tower system..."
      nix eval --raw --read-only "$DOTS_PATH/#nixosConfigurations.tower.config.system.build.toplevel"
    }

    check_work() {
      echo "🔎 Checking work home and system configs..."
      nix eval --raw --read-only "$DOTS_PATH/work#homeConfigurations.$USER.activationPackage.outPath"
      nix eval --raw --read-only "$DOTS_PATH/work#systemConfigs.default"
    }

    case "$1" in
      tower)
        check_tower;;
      work)
        check_work;;
      *)
        check_tower && check_work;;
    esac
  '';
in
{
  home.packages = [
    nix-check
  ];
}
