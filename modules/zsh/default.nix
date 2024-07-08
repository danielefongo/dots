{ pkgs, dots_path, config, ... }:

{
  home.packages = with pkgs; [
    zsh
  ];

  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/zsh/.zshrc";
}
