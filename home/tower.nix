{
  pkgs,
  user_data,
  ...
}:

{
  imports = [
    ./modules/default.nix
  ];

  home.username = user_data.user;
  home.homeDirectory = user_data.home;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  module = {
    apps.full.enable = true;
    nix.theme.enable = true;
    shell.full.enable = true;
    i3.enable = true;
    virtualisation.docker.enable = true;
    others.playerctl.enable = true;
    others.tailscale.enable = true;
    terminal.full.enable = true;
  };
  module.apps.full.firefox.profiles = {
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
