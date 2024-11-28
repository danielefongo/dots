{ pkgs, ... }:

(self: super: {
  firefox = pkgs.callPackage ./firefox { };
  sesh = pkgs.callPackage ./sesh.nix { };
})
