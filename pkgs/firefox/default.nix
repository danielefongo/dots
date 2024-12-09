{ pkgs, ... }:

let
  configJs = ./install/config.js;
  defaultPrefs = ./install/defaults/pref;
in
pkgs.stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "133.0";

  src = pkgs.fetchurl {
    name = "firefox";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.bz2";
    hash = "sha256-Y8sJcXTUKQQ60Sg0E1jRTNtdTJ0F0DXZ4wlGNM6vIsI=";
  };

  buildInputs = [ ];
  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    tar -xjf ${src}
    cd firefox
  '';

  installPhase = ''
    mkdir -p $out/lib/firefox
    mkdir -p $out/lib/firefox/browser/defaults/preferences
    cp -r * $out/lib/firefox
    mkdir -p $out/bin
    ln -s $out/lib/firefox/firefox $out/bin/firefox

    mkdir -p $out/share/icons/hicolor/128x128/apps
    cp browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/firefox.png

    cp ${configJs} $out/lib/firefox/config.js
    cp -f ${defaultPrefs}/* $out/lib/firefox/defaults/pref
  '';

  SNAP_NAME = "firefox";
}
