{ pkgs, dots_path, config, home, ... }:

{
  home.packages = with pkgs; [
    btop
  ];

  xdg.configFile."btop".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/btop";
}
