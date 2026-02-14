{
  inputs,
  pkgs,
  dots_path,
  ...
}:

(final: prev: rec {
  ocr = pkgs.callPackage ./ocr.nix { pkgs = prev; };
  tmuxinator = pkgs.callPackage ./tmuxinator.nix { pkgs = prev; };
  firefox-addons = pkgs.callPackage ./firefox-addons.nix { pkgs = prev; };
  discord = pkgs.callPackage ./discord { pkgs = prev; };
  plover = pkgs.callPackage ./plover.nix {
    inherit inputs;
    pkgs = prev;
  };

  dot = import ./dot.nix {
    inherit pkgs dots_path inputs;
  };
  nix-scripts = pkgs.callPackage ./nix-scripts {
    inherit dots_path dot;
    pkgs = prev;
  };
})
