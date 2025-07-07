{
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ../modules/base.nix
    ../modules/games.nix
    ../modules/i3.nix
    ../modules/linking.nix
    ../modules/networking.nix
    ../modules/sound.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  services.printing.enable = true;

  users.users.danielefongo = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "users"
    ];
  };

  system.stateVersion = "24.05";
}
