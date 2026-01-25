{ user_data, pkgs, ... }:

let
  userName = user_data.user;
  userHome = user_data.home;
in
{
  users.users.${userName} = {
    isNormalUser = true;
    description = userName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "users"
    ];
  };

  home-manager.users.${userName} = {
    imports = [ ../../../home ];

    home = {
      username = userName;
      homeDirectory = userHome;
      stateVersion = "25.11";
    };

    programs.home-manager.enable = true;

    cfg.firefox.profiles.personal = {
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

  home-manager.backupFileExtension = "hm-bak";
}
