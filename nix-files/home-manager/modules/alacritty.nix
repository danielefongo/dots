{ pkgs, home, ... }:

let
  wrap-nixgl = pkgs.callPackage ../helpers/wrap-nixgl.nix { };
in
{
  home.packages = with pkgs; [
    (wrap-nixgl alacritty)
  ];
}
