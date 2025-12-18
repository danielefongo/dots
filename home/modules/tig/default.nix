{ lib, pkgs, ... }:

lib.optionalModule "shell.tig" { } (cfg: {
  home.packages = with pkgs; [ tig ];

  xdg.configFile."tig".source = lib.outLink "tig";
})
