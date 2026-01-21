{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."copyq/copyq.conf".source = pkgs.outLink "copyq/copyq.conf";

  services.copyq.enable = true;
}
