{
  lib,
  pkgs,
  inputs,
  user_data,
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
    ../modules/users/daniele.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "nixos";

  services.printing.enable = true;

  system.stateVersion = "24.05";
}
