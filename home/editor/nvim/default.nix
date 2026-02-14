{ lib, pkgs, ... }:

lib.homeOpts.module "editor.nvim" { } (_: {
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

  mod.home.shell.fzf.enable = true;
  mod.home.cli.ripgrep.enable = true;
  mod.home.cli.opencode.enable = true;
})
