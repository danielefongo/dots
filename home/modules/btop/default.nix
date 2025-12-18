{ lib, pkgs, ... }:

lib.optionalModule "shell.btop" { } (cfg: {
  home.packages = with pkgs; [ btop ];

  xdg.configFile."btop".source = lib.outLink "btop";
})
