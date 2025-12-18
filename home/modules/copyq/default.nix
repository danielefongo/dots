{ lib, pkgs, ... }:

lib.optionalModule "apps.copyq" { } (cfg: {
  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."copyq/copyq.conf".source = lib.outLink "copyq/copyq.conf";

  services.copyq.enable = true;
})
