{
  inputs,
  pkgs,
  dots_path,
  ...
}:
let
  mkOverlay = file: import file { inherit pkgs dots_path inputs; };
in
final: prev:
[
  (mkOverlay ./discord)
  (mkOverlay ./dot.nix)
  (mkOverlay ./firefox-addons.nix)
  (mkOverlay ./nix-scripts)
  (mkOverlay ./plover.nix)
  (mkOverlay ./sops.nix)
  (mkOverlay ./text.nix)
  (mkOverlay ./tmuxinator.nix)
  (mkOverlay ./zen-browser.nix)
]
|> builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) { }
