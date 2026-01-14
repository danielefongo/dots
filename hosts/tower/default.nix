{
  inputs,
  ...
}:

{
  imports = [
    ../modules/base.nix
    ../modules/bluetooth.nix
    ../modules/docker.nix
    ../modules/games.nix
    ../modules/i3.nix
    ../modules/keyboard.nix
    ../modules/linking.nix
    ../modules/networking.nix
    ../modules/onepassword.nix
    ../modules/sound.nix
    ../modules/yubikey.nix
    ../modules/users/danielefongo.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "tower";

  services.printing.enable = true;

  system.stateVersion = "25.11";
}
