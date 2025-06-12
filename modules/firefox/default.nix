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
    refined-github
    tabliss
    ublock-origin
    vimium
    videospeed
  ];
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
      extensions.packages =
        with pkgs.firefox-addons;
        [
          darkreader
          flagfox
          clearurls
        ]
        ++ common_packages;
    };

    profiles."work" = {
      id = 1;
      isDefault = true;

      extensions.packages = common_packages;
    };
  };

  home.file = {
    ".mozilla/firefox/personal/chrome".source = chromeCSS;
    ".mozilla/firefox/personal/user.js".source = userJS;
    ".mozilla/firefox/work/chrome".source = chromeCSS;
    ".mozilla/firefox/work/user.js".source = userJS;
  };
}
