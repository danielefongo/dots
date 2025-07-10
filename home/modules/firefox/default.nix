{ pkgs, ... }:
{
  imports = [ ./firefox.nix ];

  firefox = {
    enable = true;

    profiles = {
      personal = {
        isDefault = true;
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
        ];
      };
    };
  };
}
