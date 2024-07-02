{ pkgs, dots_path, config, home, ... }:

{
  home.packages = with pkgs; [
    less
  ];

  home.file.".lesskey".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/.lesskey";
}
