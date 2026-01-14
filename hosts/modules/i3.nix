{ pkgs, lib, ... }:

{
  services.displayManager.gdm.enable = true;
  services.xserver = {
    enable = true;
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
  security.pam.services = {
    i3lock.text = ''
      auth       sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=/etc/u2f_keys
      auth       required   pam_unix.so
      account    required   pam_unix.so
      password   required   pam_unix.so
      session    required   pam_unix.so
    '';
  };

  services.gnome.gnome-keyring.enable = lib.mkDefault true;
}
