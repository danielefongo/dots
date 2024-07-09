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

  xdg.configFile."nvim".source = lib.outLink "nvim";
}
