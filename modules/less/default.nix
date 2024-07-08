{ pkgs, dots_path, config, ... }:

{
  home.packages = with pkgs; [
    less
  ];

  home.file.".lesskey".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/less/.lesskey";
}
