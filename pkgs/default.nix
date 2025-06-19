{ inputs, pkgs, ... }:

(self: super: {
  ocr = pkgs.callPackage ./ocr.nix { pkgs = super; };
  tmux = pkgs.callPackage ./tmux.nix { pkgs = super; };
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  plover = pkgs.callPackage ./plover.nix {
    inherit inputs;
    pkgs = super;
  };
})
