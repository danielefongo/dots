final: prev:

let
  launcherName = "firefox";
  desktopName = "Firefox";
  wmClass = "Firefox";
  icon = "firefox";

  configJs = ./config.js;
  defaultPrefs = ./defaults/pref;

  mkItem = (profile: prev.makeDesktopItem ({
    name = prev.lib.concatStringsSep "-" [ launcherName profile ];
    exec = "${launcherName} -P ${profile} --name ${wmClass} %U";
    inherit icon;
    desktopName = prev.lib.concatStringsSep " " [ desktopName profile ];
    startupNotify = true;
    startupWMClass = wmClass;
    terminal = false;
    genericName = "Web Browser";
    categories = [ "Network" "WebBrowser" ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    actions = {
      new-private-window = {
        name = "New Private Window";
        exec = "${launcherName} --private-window %U";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = "${launcherName} --ProfileManager";
      };
    };
  }));
in
{
  firefoxWithUserJS = (profiles: prev.stdenv.mkDerivation rec {
    pname = "Firefox";
    version = "127.0";

    src = prev.fetchurl {
      name = "firefox";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.bz2";
      hash = "sha256-DRpSPyNIyzBo15LKfLMbIJ0MbI5LlbzXCPTAlqiNCuk=";
    };

    buildInputs = [ ];
    sourceRoot = ".";

    desktopItems = map mkItem profiles;

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

      for desktopItem in ${prev.lib.concatStringsSep " " desktopItems}; do
        install -D -t $out/share/applications $desktopItem/share/applications/*
      done

      cp ${configJs} $out/lib/firefox/config.js
      cp -f ${defaultPrefs}/* $out/lib/firefox/defaults/pref
    '';

    SNAP_NAME = "firefox";
  });
}
