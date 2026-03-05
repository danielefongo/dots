{ inputs, pkgs, ... }:

final: prev: {
  zen-browser = inputs.zen-browser.packages.${prev.stdenv.hostPlatform.system}.beta;
}
