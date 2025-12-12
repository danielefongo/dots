{ pkgs, ... }:

let
  version = "3.6a";
in
pkgs.tmux.overrideAttrs rec {
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = version;
    hash = "sha256-VwOyR9YYhA/uyVRJbspNrKkJWJGYFFktwPnnwnIJ97s=";
  };
}
