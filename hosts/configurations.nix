{
  pkgs,
  inputs,
  modulesPath,
  ...
}:

{
  home = user: config: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager.extraSpecialArgs = inputs // {
      inherit pkgs user;
    };

    home-manager.users.${user.name} = {
      imports = [ ../mod/home ];

      home = {
        username = user.name;
        homeDirectory = user.home;
        stateVersion = "25.11";
      };

      programs.home-manager.enable = true;
    }
    // config;

    home-manager.backupFileExtension = "hm-bak";
  };

  host =
    user: hardware: config:
    {
      imports = [
        ../mod/host
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      users.users.${user.name} = {
        home = user.home;
        isNormalUser = true;
        description = user.name;
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
