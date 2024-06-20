{ pkgs }:

pkgs.writeShellScriptBin "rebuild" ''
  ${pkgs.home-manager}/bin/home-manager switch --flake .
''
