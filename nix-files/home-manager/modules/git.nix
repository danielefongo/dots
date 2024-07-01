{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    git
    delta
    tig
  ];

  xdg.configFile."git".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/git";
  xdg.configFile."tig".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/tig";
}
