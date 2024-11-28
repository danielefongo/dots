{ pkgs, ... }:

(self: super: {
  firefox = pkgs.callPackage ./firefox { };
})
