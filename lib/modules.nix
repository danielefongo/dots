{ lib, ... }:

with lib;
let
  modulesIn =
    dir:
    pipe dir [
      builtins.readDir
      (filterAttrs (
        name: type:
        (type == "regular" && hasSuffix ".nix" name && name != "default.nix")
        || (type == "directory" && pathExists (dir + "/${name}/default.nix"))
      ))
      (mapAttrsToList (name: _: dir + "/${name}"))
    ];

  package = name: pkg: {
    imports = [
      (opts.module "${name}" { } (cfg: {
        home.packages = [ pkg ];
      }))
    ];
  };
in
{
  inherit
    modulesIn
    opts
    package
    ;
}
