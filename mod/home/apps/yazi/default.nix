{ lib, pkgs, ... }:

let
  yazi-open = pkgs.writeShellScriptBin "yazi-open" ''
    ${pkgs.kitty}/bin/kitty -e yazi "''${1:-~}"
  '';
in
lib.homeOpts.module "apps.yazi" { } (_: {
  xdg.desktopEntries.yazi = {
    name = "Yazi";
    comment = "Yazi";
    exec = "${yazi-open}/bin/yazi-open %u";
    icon = "folder";
    type = "Application";
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
    };
  };

  mod.home.cli.yazi.enable = true;
})
