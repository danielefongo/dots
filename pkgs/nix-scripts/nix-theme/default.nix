{
  pkgs,
  dots_path,
}:

let
  theme_package = pkgs.mkYarnPackage {
    name = "theme";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };

  script = pkgs.writeShellApplication {
    name = "nix-theme";
    runtimeInputs = [ pkgs.libnotify ];
    text = ''
      #!${pkgs.runtimeShell}
      set -eo pipefail
      ${theme_package}/bin/theme "''${1:-}" "${dots_path}/themes/base.js" "${dots_path}" "${dots_path}/output"
    '';
  };
in
script
