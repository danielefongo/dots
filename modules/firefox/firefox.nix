{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.firefox;

  makeDesktopItem =
    profileName: profileCfg:
    pkgs.makeDesktopItem {
      name = "firefox-${profileName}";
      exec = "${pkgs.firefox}/bin/firefox -P ${profileName} --name Firefox %U";
      desktopName = "Firefox ${profileName}";
      icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
      startupNotify = true;
      startupWMClass = "Firefox";
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
    };

in
{
  options.firefox = {
    enable = mkEnableOption "Enable Firefox configuration with modular profiles";

    profiles = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "Enable this Firefox profile";

            isDefault = mkOption {
              type = types.bool;
              default = false;
              description = "Set this profile as the default one.";
            };

            addons = mkOption {
              type = types.listOf types.package;
              default = [ ];
              description = "Additional Firefox extensions";
            };

            id = mkOption {
              type = types.int;
              description = "Profile ID, used by Firefox to identify the profile";
            };
          };
        }
      );
      default = { };
      description = "Map of Firefox profiles to be configured";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies.ExtensionSettings."*" = {
        installation_mode = "force_installed";
        allowed_types = [ "extension" ];
      };

      profiles = lib.mapAttrs (
        name: profileCfg:
        mkIf profileCfg.enable {
          id = profileCfg.id;
          isDefault = profileCfg.isDefault;
          extensions.packages = profileCfg.addons;
        }
      ) cfg.profiles;
    };

    home.packages = lib.mapAttrsToList (
      name: profileCfg:
      mkIf (profileCfg.enable && !profileCfg.isDefault) (makeDesktopItem name profileCfg)
    ) cfg.profiles;

    home.file = mkMerge (
      lib.mapAttrsToList (
        name: profileCfg:
        mkIf profileCfg.enable {
          ".mozilla/firefox/${name}/user.js".source = lib.outLink "firefox/user.js";
          ".mozilla/firefox/${name}/chrome".source = lib.outLink "firefox/chrome";
        }
      ) cfg.profiles
    );
  };
}
