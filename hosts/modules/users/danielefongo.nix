{
  user_data,
  ...
}:

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

    module.apps.enable = true;
    module.cli.enable = true;
    module.desktop.enable = true;
    module.editor.enable = true;
    module.shell.enable = true;
    module.system.enable = true;
    module.terminal.enable = true;
  };

  home-manager.backupFileExtension = "hm-bak";
}
