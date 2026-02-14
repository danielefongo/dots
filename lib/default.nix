{
  lib,
  inputs,
  ...
}:

let
  inherit (builtins) map;
  inherit (lib) foldr;

  modules = importLib ./modules.nix;

  importLib = file: import file { inherit inputs lib; };
  merge = foldr (a: b: a // b) { };
  importLibs = libs: merge (map importLib libs);

  libModules = modules.modulesIn ./. |> map toString |> importLibs;
in
lib.extend (final: prev: prev // libModules)
