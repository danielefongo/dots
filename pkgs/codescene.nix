{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "cs";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://downloads.codescene.io/enterprise/cli/cs-linux-amd64-latest.zip";
    sha256 = "sha256-m96rO+88QFy0i5rpJCGee1wAcnJ/RGRdQ6f3KEMSHcQ=";
  };
  nativeBuildInputs = [ pkgs.unzip ];

  unpackPhase = ''
    mkdir -p $out
    unzip $src -d $out
  '';

  installPhase = ''
    mkdir -p $out/bin

    mv $out/cs $out/bin/cs
    chmod +x $out/bin/cs
  '';
}
