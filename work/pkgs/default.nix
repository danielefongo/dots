{ pkgs, ... }:

(self: super: {
  codescene-cli = pkgs.callPackage ./codescene.nix { pkgs = super; };
})
