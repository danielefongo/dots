#!/usr/bin/env bash
cd "$DOTS_PATH"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

get_packages() {
  local flake_ref="$1"
  local attr_path="$2"
  local out

  if ! out=$(nix eval --no-warn-dirty --json "$flake_ref#$attr_path" \
    --apply '
            ps: let
                cleaned = builtins.filter 
                    (p: (p ? pname) || (p ? name) || (p ? meta && p.meta ? name))
                    ps;
            in builtins.map (p:
                let
                    pname = if p ? pname then p.pname
                        else if p ? name then (builtins.parseDrvName p.name).name
                        else if p ? meta && p.meta ? name then p.meta.name
                        else "(unknown)";
                    ver = if p ? version then p.version
                        else if p ? name then ((builtins.parseDrvName p.name).version or "")
                        else "";
                in { inherit pname ver; }
            ) cleaned
        '); then
    echo -e "${RED}✗ nix eval failed for $flake_ref#$attr_path${NC}" >&2
    return 1
  fi

  echo "$out" | jq -r '.[] | [.pname, .ver] | @tsv' | sort -u -k1,1
}

list_packages() {
  local path="$1"
  local attr_path="$2"

  if ! packages=$(get_packages "$path" "$attr_path"); then
    return 1
  fi

  while IFS=$'\t' read -r pname version; do
    [[ -n "$pname" ]] || continue
    if [[ -n "$version" ]]; then
      echo -e "${BLUE}• $pname${NC} ${version}"
    else
      echo -e "${BLUE}• $pname${NC}"
    fi
  done <<<"$packages"
}

build_diff() {
  local path="$1"
  local attr_path="$2"

  if ! old_packages=$(get_packages "git+file://$PWD?dir=$path&ref=main&rev=$(git rev-parse main)" "$attr_path"); then
    return 1
  fi

  if ! new_packages=$(get_packages "$path" "$attr_path"); then
    return 1
  fi

  declare -A old_packages_map new_packages_map
  local updated_packages=()
  local added_packages=()
  local removed_packages=()

  while IFS=$'\t' read -r pname version; do
    [[ -n "$pname" ]] || continue
    old_packages_map["$pname"]="$version"
  done <<<"$old_packages"

  while IFS=$'\t' read -r pname version; do
    [[ -n "$pname" ]] || continue
    new_packages_map["$pname"]="$version"

    if [[ "${old_packages_map[$pname]+_}" ]]; then
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
    echo -e "${YELLOW}~ $pname ${old_ver:-?} -> ${new_ver:-?}${NC}"
  done

  for package in "${added_packages[@]}"; do
    echo -e "${GREEN}+ $package${NC}"
  done

  for package in "${removed_packages[@]}"; do
    echo -e "${RED}- $package${NC}"
  done
}

nixos_all() {
  local mode="$1"
  mapfile -t hosts < <(nix eval --no-warn-dirty --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]')

  for h in "${hosts[@]}"; do
    if [[ "$mode" == "diff" ]]; then
      echo "🔎 packages diff on nixos: $h home"
      build_diff "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
    else
      echo "🔎 packages on nixos: $h home"
      list_packages "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
    fi
  done
}

nixos_some() {
  local mode="$1"
  shift

  for h in "$@"; do
    if [[ "$mode" == "diff" ]]; then
      echo "🔎 packages diff on nixos: $h home"
      build_diff "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
    else
      echo "🔎 packages on nixos: $h home"
      list_packages "." "nixosConfigurations.$h.config.home-manager.users.$USER.home.packages"
    fi
  done
}

work() {
  local mode="$1"
  if [[ "$mode" == "diff" ]]; then
    echo "🔎 packages diff on work home"
    build_diff "./work" "homeConfigurations.$USER.config.home.packages"
  else
    echo "🔎 packages on work home"
    list_packages "./work" "homeConfigurations.$USER.config.home.packages"
  fi
}

# Parse arguments to extract mode and filter out -d
mode="list"
args=()
for arg in "$@"; do
  if [[ "$arg" == "-d" ]]; then
    mode="diff"
  else
    args+=("$arg")
  fi
done

case "${args[0]:-}" in
nixos)
  if ((${#args[@]} > 1)); then
    nixos_some "$mode" "${args[@]:1}"
  else
    nixos_all "$mode"
  fi
  ;;
work)
  work "$mode"
  ;;
*)
  nixos_all "$mode"
  work "$mode"
  ;;
esac
