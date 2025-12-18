{ lib, ... }:

lib.optionalModule "apps.firefox"
  {
    profiles = {
      type = lib.types.attrs;
    };
  }
  (cfg: {
    imports = [ ./firefox.nix ];

    firefox = {
      enable = true;

      profiles = cfg.profiles;
    };
  })
