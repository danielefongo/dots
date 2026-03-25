{
  lib,
  pkgs,
  ...
}:
lib.homeOpts.module "apps.zen-browser"
  {
    extraProfiles = {
      type = lib.types.attrs;
      default = { };
    };
    default = {
      type = lib.types.bool;
      default = false;
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
            {
              addon = onepassword-password-manager;
              pinned = true;
            }
            {
              addon = ublock-origin;
              pinned = true;
            }
            darkreader
            tabliss
            flagfox
            clearurls
            vimium
            videospeed
          ];
        };
      };

      allProfiles = personalProfile // moduleConfig.extraProfiles;
    in
    {
      imports = [ ./package.nix ];

      zen-browser = {
        enable = true;
        default = moduleConfig.default;
        profiles = allProfiles;
      };
    }
  )
