{ pkgs, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    git
    delta
  ];

  xdg.configFile."git".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/git";
}
