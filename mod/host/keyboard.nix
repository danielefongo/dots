{
  lib,
  pkgs,
  user,
  ...
}:

lib.hostOpts.module "keyboard" { } (_: {
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3297", ATTRS{idProduct}=="0791", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666"
  '';

  users.users."${user.name}".extraGroups = [ "plugdev" ];
})
