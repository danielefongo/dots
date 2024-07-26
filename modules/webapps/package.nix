{ pkgs, ... }:

let
  toWebAppConfig =
    (profile: pkgs.writeText "config" ''
      module.exports = {
        title: "${profile.name}",
        site: "${profile.site}",
        ${if profile ? css then "css: \"${profile.css}\"," else ""}
        ${if profile ? icon then "icon: \"${profile.icon}\"," else ""}
        ${if profile ? userAgent then "userAgent: \"${profile.userAgent}\"," else ""}
        bindings: [
          {
            key: "CommandOrControl+Shift+I",
            action: (view) => view.webContents.toggleDevTools(),
          },
          {
            key: "CommandOrControl+M",
            action: (view) => view.webContents.goBack(),
          },
          {
            key: "CommandOrControl+I",
            action: (view) => view.webContents.goForward(),
          },
        ]
      };
    '');
  mkItem = (profile: pkgs.makeDesktopItem ({
    name = profile.name;
    exec = "web-app --config ${toWebAppConfig profile}";
    desktopName = profile.name;
    startupNotify = true;
    startupWMClass = profile.name;
    terminal = false;
    mimeTypes = [ ];
  } // (
    if profile ? icon then { icon = "${profile.icon}"; } else { }
  )));
in
(profile: pkgs.stdenv.mkDerivation rec {
  pname = "WebApp";
  version = "0.0.6";

  src = pkgs.fetchurl {
    name = "web-app";
    url = "https://github.com/danielefongo/web-app/releases/download/v${version}/WebApp-${version}.AppImage";
    hash = "sha256-hB0sZhiUmFxSns0dhmhGGxU9NtylLG8txiWTtq6p3Wc=";
  };

  buildInputs = [ ];
  sourceRoot = ".";

  desktopItem = mkItem profile;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/web-app
    chmod +x $out/bin/web-app

    install -D -t $out/share/applications $desktopItem/share/applications/*
  '';
})
