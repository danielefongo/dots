{ lib, pkgs, ... }:

let
  version = "3.4";
in
pkgs.tmux.overrideAttrs rec {
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    hash = "sha256-RX3RZ0Mcyda7C7im1r4QgUxTnp95nfpGgQ2HRxr0s64=";
  };
}
