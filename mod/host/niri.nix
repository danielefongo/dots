{
  pkgs,
  lib,
  ...
}:

lib.hostOpts.module "niri" { } (_: {
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  programs.niri.enable = true;

  security.pam.services = {
    swaylock.text = ''
      auth       sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=/etc/u2f_keys
      auth       required   pam_unix.so
      account    required   pam_unix.so
      password   required   pam_unix.so
      session    required   pam_unix.so
    '';
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    wayland
    (xwayland-satellite.overrideAttrs (
      final: prev: {
        version = "0.8.0";
        src = fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          rev = "9a71e77b1e06dbad4a472265e59b52ac83cbe00c";
          sha256 = "sha256-Qz1WvGdawnoz4dG3JtCtlParmdQHM5xu6osnXeVOqYI=";
        };

        cargoDeps = prev.cargoDeps.overrideAttrs (
          _: prev': {
            vendorStaging = prev'.vendorStaging.overrideAttrs {
              inherit (final) src;
              outputHash = "sha256-HGrMjNIsUqh8AFtSABk615x4B9ygrVEn26V0G1kX/nA=";
            };
          }
        );
      }
    ))
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      gnome-keyring
    ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
})
