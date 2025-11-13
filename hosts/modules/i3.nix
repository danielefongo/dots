{ pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    windowManager.i3.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  programs.i3lock = {
    enable = true;
    package = pkgs.i3lock-color;
  };

  services.gnome.gnome-keyring.enable = lib.mkDefault true;
}
