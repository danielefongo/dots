{
  pkgs,
  inputs,
  modulesPath,
  ...
}:

{
  home = user_data: config: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager.extraSpecialArgs = inputs // {
      inherit pkgs user_data;
    };

    home-manager.users.${user_data.user} = {
      imports = [ ../mod/home ];

      home = {
        username = user_data.user;
        homeDirectory = user_data.home;
        stateVersion = "25.11";
      };

      programs.home-manager.enable = true;
    }
    // config;

    home-manager.backupFileExtension = "hm-bak";
  };

  host =
    user_data: hardware: config:
    {
      imports = [
        ../mod/host
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      users.users.${user_data.user} = {
        home = user_data.home;
        isNormalUser = true;
        description = user_data.user;
        extraGroups = [
          "networkmanager"
          "wheel"
          "dialout"
          "users"
        ];
      };

      system.stateVersion = "25.11";
    }
    // hardware
    // config;
}
