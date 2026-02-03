{ lib, pkgs, ... }:

lib.opts.module "editor.nvim" { } (cfg: {
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
      gh # snacks integration
      tree-sitter
    ];
  };

  xdg.configFile."nvim/init.lua".source = pkgs.dot.outLink "nvim/init.lua";
  xdg.configFile."nvim/lua".source = pkgs.dot.outLink "nvim/lua";
  xdg.configFile."nvim/lazy-lock.json".source = pkgs.dot.link "home/editor/nvim/lazy-lock.json";

  home.packages = with pkgs; [
    python3 # mason
    nodejs # copilot
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  module.shell.fzf.enable = true;
  module.cli.enable = true;
})
