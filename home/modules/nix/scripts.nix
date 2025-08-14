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

  nix-packages = pkgs.writeShellScriptBin "nix-packages" ''
    #!${pkgs.runtimeShell}

    DOTS_PATH="${user_data.dots_path}"
    USER="${user_data.user}"

    cd "$DOTS_PATH" 

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'

    get_packages() {
      local flake_ref="$1"
      local attr_path="$2"
      nix eval --no-warn-dirty --json "$flake_ref#$attr_path" \
        --apply '
          ps:
            builtins.map (p:
              let parsed = builtins.parseDrvName p.name;
                  pname  = if p ? pname then p.pname else parsed.name;
                  ver    = if p ? version then p.version else (parsed.version or "");
              in { inherit pname ver; }
            ) ps
        ' |
        jq -r '.[] | [.pname, .ver] | @tsv' |
        sort -u -k1,1
    }

    build_diff() {
      local path="$1"
      local attrPath="$2"

      old_packages=$(get_packages "git+file://$PWD?dir=$path&ref=main&rev=$(git rev-parse main)" "$attrPath")
      new_packages=$(get_packages $path "$attrPath")

      old_file=$(mktemp)
      new_file=$(mktemp)

      echo "$old_packages" >"$old_file"
      echo "$new_packages" >"$new_file"

      declare -A old_packages_map new_packages_map
      updated_packages=()
      added_packages=()
      removed_packages=()

      while IFS=$'\t' read -r pname version; do
        [[ -n "$pname" ]] || continue
        old_packages_map["$pname"]="$version"
      done <<<"$old_packages"

      while IFS=$'\t' read -r pname version; do
        [[ -n "$pname" ]] || continue
        new_packages_map["$pname"]="$version"

        if [[ -n "''${old_packages_map[$pname]}" || "''${old_packages_map[$pname]+_}" ]]; then
          if [[ "''${old_packages_map[$pname]}" != "$version" ]]; then
            updated_packages+=("$pname")
          fi
        else
          added_packages+=("$pname"$([[ -n "$version" ]] && echo "-$version"))
        fi
      done <<<"$new_packages"

      for pname in "''${!old_packages_map[@]}"; do
        if [[ -z "''${new_packages_map[$pname]+_}" ]]; then
          old_ver="''${old_packages_map[$pname]}"
          removed_packages+=("$pname"$([[ -n "$old_ver" ]] && echo "-$old_ver"))
        fi
      done

      for pname in "''${updated_packages[@]}"; do
        old_ver="''${old_packages_map[$pname]}"
        new_ver="''${new_packages_map[$pname]}"
        echo -e "''${YELLOW}~ $pname ''${old_ver:-?} -> ''${new_ver:-?} ''${NC}"
      done

      for package in "''${added_packages[@]}"; do
        echo -e "''${GREEN}+ $package''${NC}"
      done

      for package in "''${removed_packages[@]}"; do
        echo -e "''${RED}- $package''${NC}"
      done

      rm -f "$old_file" "$new_file"
    }

    tower() {
      echo "🔎 Packages diff on tower home..."
      build_diff "." "nixosConfigurations.tower.config.home-manager.users.$USER.home.packages"
    }

    work() {
      echo "🔎 Packages diff on work home..."
      build_diff "./work" "homeConfigurations.$USER.config.home.packages"
    }

    case "$1" in
      tower)
        tower;;
      work)
        work;;
      all)
        tower;
        echo
        work;;
    esac
  '';

  nix-update-flakes = pkgs.writeShellScriptBin "nix-update-flakes" ''
    #!${pkgs.runtimeShell}
    set -euo pipefail

    DOTS_PATH="${user_data.dots_path}"

    cd "$DOTS_PATH"

    echo "🔄 Updating flakes..."
    nix flake update --flake .
    nix flake update --flake ./work

    ${nix-packages}/bin/nix-packages all
  '';
in
{
  home.packages = [
    nix-check
    nix-packages
    nix-update-flakes
  ];
}
