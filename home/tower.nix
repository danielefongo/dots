{
  pkgs,
  user_data,
  ...
}:

{
  imports = [ ./modules ];

  home.username = user_data.user;
  home.homeDirectory = user_data.home;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = [ pkgs.google-chrome ];
  cfg.firefox.enable = false;
  cfg.firefox.profiles = {
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
        libredirect
      ];
    };
  };
}
