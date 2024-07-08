{ dots_path, config, ... }:

{
  xdg.configFile."mise".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/mise";
}
