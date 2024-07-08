{ pkgs, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

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
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/nvim";
}
