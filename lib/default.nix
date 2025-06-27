{
  inputs,
  pkgs,
  dots_path,
  ...
}:

let
  inherit (builtins) attrValues map;
  inherit (pkgs.lib) foldr;

  modules = importLib ./modules.nix;

  importLib = file: import file { inherit inputs pkgs dots_path; };
  merge = foldr (a: b: a // b) { };
  importLibs = libs: merge (map importLib libs);

  libModules = modules.modulesIn ./. |> attrValues |> map toString |> importLibs;
in
pkgs.lib.extend (self: super: super // libModules)
