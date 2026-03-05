{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.zen-browser;

  addonsConfigs =
    cfg:
    let
      sanitizeAddonId =
        addonId:
        let
          sanitizeChar = c: if builtins.match "[a-z0-9-]" c != null then c else "_";
        in
        lib.concatStrings (map sanitizeChar (lib.stringToCharacters (lib.toLower addonId)));

      isPackage = cfg: cfg ? type && cfg.type == "derivation";
      addonCfg =
        if isPackage cfg then
          {
            addon = cfg;
            pinned = false;
          }
        else
          cfg;
    in
    {
      inherit (addonCfg) addon pinned;
      browserAction = "${sanitizeAddonId addonCfg.addon.addonId}-browser-action";
    };

  addonsPackages = configs: configs |> map (c: c.addon);
  unifiedAddonsActions =
    configs: configs |> builtins.filter (c: !c.pinned) |> map (c: c.browserAction);
  pinnedAddonsActions = configs: configs |> builtins.filter (c: c.pinned) |> map (c: c.browserAction);

  nonDefaultDesktopEntries =
    cfg.profiles
    |> lib.filterAttrs (profileName: p: !p.isDefault)
    |> lib.mapAttrsToList (
      profileName: p: {
        name = "zen-" + profileName;
        value = {
          name = "Zen " + profileName;
          exec = "${config.programs.zen-browser.finalPackage}/bin/zen-beta -P ${profileName} %U";
          icon = "${pkgs.zen-browser}/share/icons/hicolor/128x128/apps/zen-browser.png";
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
  options.zen-browser = {
    enable = lib.mkEnableOption "Enable custom Zen configuration";

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    policies = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.int;
            };
            sine = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            isDefault = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            addons = lib.mkOption {
              type = lib.types.listOf (
                lib.types.either lib.types.package (
                  lib.types.submodule {
                    options = {
                      addon = lib.mkOption {
                        type = lib.types.package;
                      };
                      pinned = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                      };
                    };
                  }
                )
              );
              default = [ ];
            };
            settings = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      suppressXdgMigrationWarning = true;
      enable = true;
      profiles =
        cfg.profiles
        |> lib.mapAttrs (
          profileName: p:
          let
            configs = map addonsConfigs p.addons;
            addons = addonsPackages configs;
            unifiedAddons = unifiedAddonsActions configs;
            pinnedAddons = pinnedAddonsActions configs;
          in
          {
            id = p.id;
            sine.enable = p.sine;
            isDefault = p.isDefault;
            extensions.packages = addons;
            settings = {
              # Disable welcome screen
              "zen.welcome-screen.seen" = true;

              # Theme
              "sine.engine.auto-update" = false;
              "ui.systemUsesDarkTheme" = 1;

              # Autoinstall extensions
              "extensions.autoDisableScopes" = 0;
              "extensions.enabledScopes" = 15;

              # DevTools
              "devtools.debugger.remote-enabled" = true;
              "devtools.chrome.enabled" = true;

              # Others
              "browser.aboutConfig.showWarning" = false;
              "browser.tabs.groups.hoverPreview.enabled" = true;
              "browser.tabs.hoverPreview.enabled" = true;
              "browser.tabs.insertAfterCurrent" = true;
              "browser.tabs.selectOwnerOnClose" = false;
              "browser.tabs.warnOnClose" = false;
              "browser.translations.automaticallyPopup" = false;
              "browser.urlbar.suggest.clipboard" = false;
              "browser.urlbar.suggest.history" = false;
              "browser.urlbar.suggest.recentsearches" = false;
              "network.cookie.cookieBehavior" = 5;
              "network.trr.mode" = 3;
              "network.trr.uri" = "https://firefox.dns.nextdns.io/";
              "privacy.firstparty.isolate" = true;
              "zen.downloads.download-animation" = false;
              "zen.tabs.select-recently-used-on-close" = false;
              "zen.tabs.show-newtab-vertical" = false;
              "zen.view.compact.toolbar-flash-popup" = true;
              "zen.view.compact.toolbar-flash-popup.duration" = 1000;
              "zen.window-sync.sync-only-pinned-tabs" = true;
              "zen.workspaces.continue-where-left-off" = true;

              # UI Customization
              "browser.uiCustomization.state" = builtins.toJSON {
                placements = {
                  widget-overflow-fixed-list = [ ];
                  unified-extensions-area = unifiedAddons;
                  nav-bar = [
                    "back-button"
                    "forward-button"
                    "stop-reload-button"
                    "customizableui-special-spring1"
                    "vertical-spacer"
                    "urlbar-container"
                    "customizableui-special-spring2"
                    "unified-extensions-button"
                  ]
                  ++ pinnedAddons;
                  toolbar-menubar = [
                    "personal-bookmarks"
                    "menubar-items"
                  ];
                  TabsToolbar = [ "tabbrowser-tabs" ];
                  vertical-tabs = [ ];
                  PersonalToolbar = [ ];
                  zen-sidebar-top-buttons = [
                    "fxa-toolbar-menu-button"
                  ];
                  zen-sidebar-foot-buttons = [
                    "downloads-button"
                    "zen-workspaces-button"
                    "zen-create-new-button"
                  ];
                };
                seen =
                  unifiedAddons
                  ++ pinnedAddons
                  ++ [
                    "developer-button"
                    "screenshot-button"
                  ];
                dirtyAreaCache = [ ];
                currentVersion = 23;
                newElementCount = 4;
              };
            }
            // p.settings;
            keyboardShortcuts = [
              {
                id = "zen-compact-mode-toggle";
                key = "s";
                modifiers.control = true;
                modifiers.alt = true;
              }
              {
                id = "key_savePage";
                key = "s";
                modifiers.control = true;
              }
              {
                id = "zen-workspace-backward";
                key = ",";
                modifiers.control = true;
                modifiers.alt = true;
              }
              {
                id = "zen-workspace-forward";
                key = ".";
                modifiers.control = true;
                modifiers.alt = true;
              }
              {
                id = "zen-new-empty-split-view";
                key = "/";
                modifiers.control = true;
                modifiers.alt = true;
              }
              {
                id = "zen-split-view-unsplit";
                key = "?";
                modifiers.control = true;
                modifiers.alt = true;
                modifiers.shift = true;
              }
            ];
          }
        );
      # https://mozilla.github.io/policy-templates/
      policies = {
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        ExtensionSettings."*" = {
          installation_mode = "force_installed";
          allowed_types = [ "extension" ];
        };
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
        PasswordManagerEnabled = false;
        Permissions = {
          Location.BlockNewRequests = true;
          Notifications.BlockNewRequests = true;
          Autoplay.BlockNewRequests = true;
          VirtualReality.BlockNewRequests = true;
        };
      };
    }
    // cfg.policies;

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
        zen-beta = {
          name = "Zen";
          exec = "${config.programs.zen-browser.finalPackage}/bin/zen-beta -P ${defaultProfile} %U";
          icon = "${pkgs.zen-browser}/share/icons/hicolor/128x128/apps/zen-browser.png";
          type = "Application";
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
      };

    xdg.mimeApps = lib.mkIf cfg.default {
      enable = true;
      defaultApplications = {
        "application/x-extension-htm" = "zen-beta.desktop";
        "application/x-extension-html" = "zen-beta.desktop";
        "application/x-extension-shtml" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "application/x-extension-xhtml" = "zen-beta.desktop";
        "application/x-extension-xht" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/chrome" = "zen-beta.desktop";
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";
      };
    };

    xdg.configFile =
      cfg.profiles
      |> lib.mapAttrsToList (
        profileName: p:
        lib.optionalAttrs p.sine {
          "zen/${profileName}/chrome/sine-mods".source = pkgs.dot.outLink "zen/sine-mods";
        }
      )
      |> lib.mkMerge;
  };
}
