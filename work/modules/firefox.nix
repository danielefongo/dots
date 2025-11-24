{ pkgs, ... }:
let
  commonAddons = with pkgs.firefox-addons; [
    onepassword-password-manager
    refined-github
    tabliss
    ublock-origin
    vimium
    videospeed
    libredirect
  ];
in
{
  imports = [ ../../home/modules/firefox/firefox.nix ];

  firefox = {
    enable = true;

    profiles = {
      personal = {
        isDefault = false;
        id = 0;
        addons =
          with pkgs.firefox-addons;
          [
            darkreader
            flagfox
            clearurls
          ]
          ++ commonAddons;
      };

      work = {
        id = 1;
        isDefault = true;
        addons =
          with pkgs.firefox-addons;
          [
            grammarly
          ]
          ++ commonAddons;
      };
    };
  };
}
