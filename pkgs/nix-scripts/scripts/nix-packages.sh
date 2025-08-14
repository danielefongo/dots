#!/usr/bin/env bash

cd "$DOTS_PATH"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

get_packages() {
  local flake_ref="$1"
  local attr_path="$2"

  local out
  if ! out=$(nix eval --no-warn-dirty --json "$flake_ref#$attr_path" \
    --apply '
      ps:
        builtins.map (p:
          let parsed = builtins.parseDrvName p.name;
              pname  = if p ? pname then p.pname else parsed.name;
              ver    = if p ? version then p.version else (parsed.version or "");
          in { inherit pname ver; }
        ) ps
    '); then
    echo -e "${RED}✗ nix eval failed for $flake_ref#$attr_path${NC}" >&2
    return 1
  fi

  echo "$out" |
    jq -r '.[] | [.pname, .ver] | @tsv' |
    sort -u -k1,1
}

build_diff() {
  local path="$1"
  local attrPath="$2"

  if ! old_packages=$(get_packages "git+file://$PWD?dir=$path&ref=main&rev=$(git rev-parse main)" "$attrPath"); then
    return 1
  fi
  if ! new_packages=$(get_packages "$path" "$attrPath"); then
    return 1
  fi

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

    if [[ -n "${old_packages_map[$pname]}" || "${old_packages_map[$pname]+_}" ]]; then
      if [[ "${old_packages_map[$pname]}" != "$version" ]]; then
        updated_packages+=("$pname")
      fi
    else
      added_packages+=("$pname${version:+ $version}")
    fi
  done <<<"$new_packages"

  for pname in "${!old_packages_map[@]}"; do
    if [[ -z "${new_packages_map[$pname]+_}" ]]; then
      old_ver="${old_packages_map[$pname]}"
      removed_packages+=("$pname${old_ver:+ $old_ver}")
    fi
  done

  for pname in "${updated_packages[@]}"; do
    old_ver="${old_packages_map[$pname]}"
    new_ver="${new_packages_map[$pname]}"
    echo -e "${YELLOW}~ $pname ${old_ver:-?} -> ${new_ver:-?} ${NC}"
  done

  for package in "${added_packages[@]}"; do
    echo -e "${GREEN}+ $package${NC}"
  done

  for package in "${removed_packages[@]}"; do
    echo -e "${RED}- $package${NC}"
  done
}

nixos_all() {
  mapfile -t hosts < <(nix eval --no-warn-dirty --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]')
  for h in "${hosts[@]}"; do
    echo "🔎 packages diff on nixos: $h home"
    build_diff "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
  done
}

nixos_some() {
  for h in "$@"; do
    echo "🔎 packages diff on nixos: $h home"
    build_diff "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
  done
}

work() {
  echo "🔎 packages diff on work home"
  build_diff "./work" "homeConfigurations.$USER.config.home.packages"
}

case "${1:-}" in
nixos)
  shift
  if (($# > 0)); then
    nixos_some "$@"
  else
    nixos_all
  fi
  ;;
work)
  work
  ;;
*)
  nixos_all
  work
  ;;
esac
