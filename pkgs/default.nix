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
  (mkOverlay ./tmuxinator.nix)
  (mkOverlay ./firefox-addons.nix)
  (mkOverlay ./discord)
  (mkOverlay ./plover.nix)
  (mkOverlay ./dot.nix)
  (mkOverlay ./nix-scripts)
  (mkOverlay ./zen-browser.nix)
]
|> builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) { }
