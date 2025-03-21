{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "cs";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://downloads.codescene.io/enterprise/cli/cs-linux-amd64-latest.zip";
    sha256 = "sha256-boQA2L3QjoIJ+upA0GwningZDk6njACkkZxASP9lJqQ=";
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
