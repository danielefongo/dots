{ pkgs, ... }:

(self: super: {
  sesh = pkgs.callPackage ./sesh.nix { pkgs = super; };
  tmux = pkgs.callPackage ./tmux.nix { pkgs = super; };
})
