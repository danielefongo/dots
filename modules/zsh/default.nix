{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    sheldon
  ];

  home.file.".zshrc".source = lib.outLink "zsh/.zshrc";
  home.file.".custom_zshrc".source = lib.outLink "zsh/.custom_zshrc";
  xdg.configFile."sheldon".source = lib.outLink "sheldon";
}
