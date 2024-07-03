{ pkgs, dots_path, config, home, ... }:

{
  xdg.configFile."mise".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/mise";
}
