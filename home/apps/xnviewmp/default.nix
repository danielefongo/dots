{ lib, pkgs, ... }:

lib.opts.module "apps.xnviewmp" { } (cfg: {
  home.packages = with pkgs; [
    xnviewmp
  ];

  xdg.desktopEntries.xnviewmp = {
    name = "XnView MP";
    comment = "Image viewer and organizer";
    exec = "xnviewmp %f";
    icon = "xnviewmp";
    terminal = false;
    categories = [
      "Graphics"
      "Viewer"
      "Photography"
    ];
    mimeType = [
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/gif"
      "image/bmp"
      "image/tiff"
      "image/webp"
      "image/svg+xml"
      "image/x-icon"
      "image/x-fuji-raf"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "xnviewmp.desktop";
      "image/jpg" = "xnviewmp.desktop";
      "image/png" = "xnviewmp.desktop";
      "image/gif" = "xnviewmp.desktop";
      "image/bmp" = "xnviewmp.desktop";
      "image/tiff" = "xnviewmp.desktop";
      "image/webp" = "xnviewmp.desktop";
      "image/svg+xml" = "xnviewmp.desktop";
      "image/x-icon" = "xnviewmp.desktop";
      "image/x-fuji-raf" = "xnviewmp.desktop";
    };
  };
})
