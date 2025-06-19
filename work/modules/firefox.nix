{
  config,
  pkgs,
  lib,
  ...
}:
let

  commonAddons = with pkgs.firefox-addons; [
    onepassword-password-manager
    refined-github
    tabliss
    ublock-origin
    vimium
    videospeed
  ];
in
{
  imports = [ ../../modules/firefox/firefox.nix ];

  firefox = {
    enable = true;

    profiles = {
      personal = {
        enable = true;
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
        enable = true;
        id = 1;
        isDefault = true;
        addons = commonAddons;
      };
    };
  };
}
