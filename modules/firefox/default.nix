{ lib, pkgs, ... }:

let
  userJS = lib.outLink "firefox/user.js";
  chromeCSS = lib.outLink "firefox/chrome";

  launcherName = "${pkgs.firefox}/bin/firefox";
  desktopName = "Firefox";
  wmClass = "Firefox";
  icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";

  makeDesktopItems = (
    profile:
    pkgs.makeDesktopItem {
      name = lib.concatStringsSep "-" [
        desktopName
        profile
      ];
      exec = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${launcherName} -P ${profile} --name ${wmClass} %U";
      inherit icon;
      desktopName = lib.concatStringsSep " " [
        desktopName
        profile
      ];
      startupNotify = true;
      startupWMClass = wmClass;
      terminal = false;
      genericName = "Web Browser";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    }
  );

  common_packages = with pkgs.firefox-addons; [
    onepassword-password-manager
    clearurls
    refined-github
    tabliss
    ublock-origin
    videospeed
  ];

  allow_cors = pkgs.firefox-addons.buildFirefoxXpiAddon {
    pname = "access-control-allow-origin";
    version = "0.2.0";
    addonId = "{c5f935cf-9b17-4b85-bed8-9277861b4116}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4376685/access_control_allow_origin-0.2.0.xpi";
    sha256 = "sha256-YCFqddv5x/1yUE1zY7FdcYU0CYaHIlS8mVax1qqQKLM=";
    meta = {
      homepage = "https://addons.mozilla.org/it/firefox/addon/access-control-allow-origin/";
      description = "Allow cors";
    };
  };
in
{
  home.packages = (
    map makeDesktopItems [
      "personal"
      "work"
    ]
  );

  programs.firefox = {
    enable = true;
    policies.ExtensionSettings = {
      "*" = {
        installation_mode = "force_installed";
        allowed_types = [ "extension" ];
      };
    };

    profiles."personal" = {
      id = 0;
      isDefault = false;
      extensions =
        with pkgs.firefox-addons;
        [
          darkreader
          flagfox
        ]
        ++ common_packages;
    };

    profiles."work" = {
      id = 1;
      isDefault = true;

      extensions = [
        allow_cors
      ] ++ common_packages;
    };
  };

  home.file = {
    ".mozilla/firefox/personal/chrome".source = chromeCSS;
    ".mozilla/firefox/personal/user.js".source = userJS;
    ".mozilla/firefox/work/chrome".source = chromeCSS;
    ".mozilla/firefox/work/user.js".source = userJS;
  };
}
