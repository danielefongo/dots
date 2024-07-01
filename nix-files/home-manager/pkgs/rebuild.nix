{ pkgs, dots_path }:

pkgs.writeShellScriptBin "nix-rebuild" ''
  cd ${dots_path}/nix-files/home-manager
  ${pkgs.home-manager}/bin/home-manager switch --flake .
''
