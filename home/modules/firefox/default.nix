{ lib, ... }:

lib.withCfg "firefox"
  {
    profiles = {
      type = lib.types.attrs;
    };
    enable = {
      type = lib.types.bool;
      default = true;
    };
  }
  (cfg: {
    imports = [ ./firefox.nix ];

    firefox = {
      enable = cfg.enable;
      profiles = cfg.profiles;
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
  })
