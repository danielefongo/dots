{ pkgs, user_data, ... }:

let
  nix-script-gen =
    name: file:
    pkgs.writeShellScriptBin name ''
      #!${pkgs.runtimeShell}
      DOTS_PATH="${user_data.dots_path}"
      USER="${user_data.user}"
      ${builtins.readFile file}
    '';
in
{
  nix-theme = pkgs.callPackage ./nix-theme {
    inherit user_data pkgs;
  };

  nix-rebuild = nix-script-gen "nix-rebuild" ./scripts/nix-rebuild.sh;
  nix-check = nix-script-gen "nix-check" ./scripts/nix-check.sh;
  nix-packages = nix-script-gen "nix-packages" ./scripts/nix-packages.sh;
  nix-tools = nix-script-gen "nix-tools" ./scripts/nix-tools.sh;
  nix-update-flakes = nix-script-gen "nix-update-flakes" ./scripts/nix-update-flakes.sh;
}
