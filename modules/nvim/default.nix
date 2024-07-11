{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      fzf
      ripgrep
      python3
      nixpkgs-fmt
      nixd
    ];
  };

  xdg.configFile."nvim/init.lua".source = lib.outLink "nvim/init.lua";
  xdg.configFile."nvim/lua".source = lib.outLink "nvim/lua";
  xdg.configFile."nvim/lazy-lock.json".source = lib.dotLink "modules/nvim/lazy-lock.json";
}
