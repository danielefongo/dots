{ pkgs, dots_path, config, ... }:

let
  wrap-nixgl = pkgs.callPackage ../../helpers/wrap-nixgl.nix { };
in
{
  home.packages = with pkgs; [
    (wrap-nixgl alacritty)
  ];

  xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/alacritty";
}
