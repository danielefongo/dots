{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.firefox;

  nonDefaultDesktopEntries =
    cfg.profiles
    |> lib.filterAttrs (profileName: p: !p.isDefault)
    |> lib.mapAttrsToList (
      profileName: p: {
        name = "firefox-" + profileName;

        value = {
          name = "Firefox " + profileName;
          exec = "${config.programs.firefox.finalPackage}/bin/firefox -P ${profileName} --name Firefox %U";
          icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
          type = "Application";
          categories = [
            "Network"
            "WebBrowser"
          ];
          mimeType = [ ];
        };
      }
    );
in
{
  options.firefox = {
    enable = lib.mkEnableOption "Enable custom Firefox configuration";

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

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
      profiles =
        cfg.profiles
        |> lib.mapAttrs (
          profileName: p: {
            id = p.id;
            isDefault = p.isDefault;
            extensions.packages = p.addons;
          }
        );
      policies = {
        ExtensionSettings."*" = {
          installation_mode = "force_installed";
          allowed_types = [ "extension" ];
        };
        Preferences = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = {
            Value = true;
            Status = "locked";
          };
          "extensions.autoDisableScopes" = {
            Value = 0;
            Status = "locked";
          };
          "browser.theme.toolbar-theme" = {
            Value = 0;
            Status = "locked";
          };
          "browser.theme.content-theme" = {
            Value = 0;
            Status = "locked";
          };
        };
      };
    };

    xdg.desktopEntries =
      let
        defaultProfile =
          cfg.profiles
          |> lib.filterAttrs (name: p: p.isDefault)
          |> lib.mapAttrsToList (name: p: name)
          |> lib.head;
      in
      lib.listToAttrs nonDefaultDesktopEntries
      // {
        firefox = {
          name = "Firefox";
          exec = "${config.programs.firefox.finalPackage}/bin/firefox -P ${defaultProfile} --name Firefox %U";
          icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
          type = "Application";
          categories = [
            "Network"
            "WebBrowser"
          ];
          mimeType = [ ];
        };
      };

    xdg.mimeApps = lib.mkIf cfg.default {
      enable = true;
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    home.file =
      cfg.profiles
      |> lib.mapAttrsToList (
        profileName: p: {
          ".mozilla/firefox/${profileName}/chrome".source = pkgs.dot.outLink "firefox/chrome";
        }
      )
      |> lib.mkMerge;
  };
}
