{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.firefox;

  defaultProfileName = builtins.head (
    lib.attrNames (lib.filterAttrs (profileName: p: p.isDefault) cfg.profiles)
  );

  staticEntry = {
    name = "firefox";
    value = {
      name = "Firefox";
      exec = "${pkgs.firefox}/bin/firefox %u";
      icon = "firefox";
      type = "Application";
      noDisplay = true;
    };
  };

  dynamicEntries = lib.filter (e: e != null) (
    lib.mapAttrsToList (profileName: p: {
      name = "firefox-" + profileName;
      value = {
        name = if profileName == defaultProfileName then "Firefox" else "Firefox " + profileName;
        exec = "${pkgs.firefox}/bin/firefox -P " + profileName + " --name Firefox %U";
        icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
        type = "Application";
        genericName = "Web Browser";
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
      };
    }) cfg.profiles
  );

  allEntries = [ staticEntry ] ++ dynamicEntries;
in

{
  options.firefox = {
    enable = lib.mkEnableOption "Enable custom Firefox configuration";

    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.int;
            };
            isDefault = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            addons = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      policies.ExtensionSettings."*" = {
        installation_mode = "force_installed";
        allowed_types = [ "extension" ];
      };
      profiles = lib.mapAttrs (profileName: p: {
        id = p.id;
        isDefault = p.isDefault;
        extensions.packages = p.addons;
      }) cfg.profiles;
    };

    xdg.desktopEntries = lib.listToAttrs allEntries;

    home.file = lib.mkMerge (
      lib.mapAttrsToList (profileName: p: {
        ".mozilla/firefox/${profileName}/user.js".source = lib.outLink "firefox/user.js";
        ".mozilla/firefox/${profileName}/chrome".source = lib.outLink "firefox/chrome";
      }) cfg.profiles
    );
  };
}
