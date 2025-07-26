{ lib, pkgs, ... }:

{
  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gcc
      openssh
      gnumake
      fzf
      ripgrep
      nodejs
      python3
      nixfmt-rfc-style
      nixd
      file
      cargo # mason
      entr
    ];
  };

  xdg.configFile."nvim/init.lua".source = lib.outLink "nvim/init.lua";
  xdg.configFile."nvim/lua".source = lib.outLink "nvim/lua";
  xdg.configFile."nvim/lazy-lock.json".source = lib.dotLink "home/modules/nvim/lazy-lock.json";

  home.packages = [
    pkgs.python3 # mason
  ];
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
}
