{ pkgs, ... }:

(self: super: {
  tmux = pkgs.callPackage ./tmux.nix { pkgs = super; };
})
