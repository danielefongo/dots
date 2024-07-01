{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    mise
  ];

  xdg.configFile."mise".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/mise";
}
