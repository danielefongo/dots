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
        name = "firefox " + profileName;
        value = {
          name = "Firefox " + profileName;
          exec = "${config.programs.firefox.finalPackage}/bin/firefox -P ${profileName} --name Firefox %U";
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
      }
    );
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

    xdg.desktopEntries = lib.listToAttrs nonDefaultDesktopEntries;

    home.file =
      cfg.profiles
      |> lib.mapAttrsToList (
        profileName: p: {
          ".mozilla/firefox/${profileName}/chrome".source = pkgs.outLink "firefox/chrome";
        }
      )
      |> lib.mkMerge;
  };
}
