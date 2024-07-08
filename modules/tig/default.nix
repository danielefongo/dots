{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    tig
  ];

  xdg.configFile."tig".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/tig";
}
