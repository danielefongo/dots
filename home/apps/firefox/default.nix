{ lib, pkgs, ... }:

lib.homeOpts.module "apps.firefox"
  {
    extraProfiles = {
      type = lib.types.attrs;
      default = { };
    };
  }
  (
    { moduleConfig, ... }:
    let
      hasExtraDefault = lib.any (p: p.isDefault or false) (lib.attrValues moduleConfig.extraProfiles);

      personalProfile = {
        personal = {
          isDefault = !hasExtraDefault;
          id = 0;
          addons = with pkgs.firefox-addons; [
            darkreader
            flagfox
            clearurls
            onepassword-password-manager
            refined-github
            tabliss
            ublock-origin
            vimium
            videospeed
            libredirect
            yet-another-smooth-scrolling
          ];
        };
      };

      allProfiles = personalProfile // moduleConfig.extraProfiles;
    in
    {
      imports = [ ./firefox.nix ];

      firefox = {
        enable = true;
        profiles = allProfiles;
      };

      xdg.mimeApps = {
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
    }
  )
