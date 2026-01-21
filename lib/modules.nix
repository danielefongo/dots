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

  withCfg = name: paramSpec: moduleConfigFn: {
    imports = [
      ((opts.withConfig { prefix = "cfg"; }).module name paramSpec (cfg: moduleConfigFn cfg))
    ];

    cfg.${name}.enable = true;
  };
in
{
  inherit
    modulesIn
    withCfg
    opts
    ;
}
