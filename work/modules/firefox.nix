{ pkgs, ... }:
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

    exec = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.firefox}/bin/firefox";

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
        addons = commonAddons;
      };
    };
  };
}
