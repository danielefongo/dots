{ pkgs, ... }:

(self: super: {
  firefox = pkgs.callPackage ./firefox { pkgs = super; };
  sesh = pkgs.callPackage ./sesh.nix { pkgs = super; };
  tmux = pkgs.callPackage ./tmux.nix { pkgs = super; };
})
