{
  pkgs,
  dots_path,
  ...
}:

final: prev: {
  nix-theme = prev.callPackage ./nix-theme {
    inherit dots_path;
  };
  nix-rebuild = prev.dot.script "nix-rebuild" ./scripts/nix-rebuild.sh [ ];
  nix-check = prev.dot.script "nix-check" ./scripts/nix-check.sh [ prev.jq ];
  nix-packages = prev.dot.script "nix-packages" ./scripts/nix-packages.sh [ prev.jq ];
  nix-tools = prev.dot.script "nix-tools" ./scripts/nix-tools.sh [ ];
  nix-update = prev.dot.script "nix-update" ./scripts/nix-update.sh [ prev.zsh ];
}
