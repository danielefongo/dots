{ lib, pkgs, ... }:

let
  version = "2.3.3";
in
pkgs.stdenv.mkDerivation rec {
  pname = "sesh";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/joshmedeski/sesh/releases/download/v${version}/sesh_Linux_x86_64.tar.gz";
    sha256 = "sha256-Qw/3RmEAOZF9PNuBKi6EjYc3GF68WTFG3GNyfFk1p0Q=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    mkdir -p $out/bin
    cp sesh $out/bin/
    chmod +x $out/bin/sesh
  '';
}
