{ lib, ... }:

with lib;
let
  homeOpts = lib.opts.withConfig {
    prefix = "mod.home";
  };
  hostOpts = lib.opts.withConfig {
    prefix = "mod.host";
  };
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
      (homeOpts.module "${name}" { } (_: {
        home.packages = [ pkg ];
      }))
    ];
  };

  hasHomeModule =
    config: module:
    let
      path = [
        "mod"
        "home"
      ]
      ++ (splitString "." module)
      ++ [ "enable" ];
      users = if config ? home-manager then config.home-manager.users else { current = config; };
    in
    any (user: (attrByPath path false user) == true) (attrValues users);
in
{
  inherit
    modulesIn
    package
    homeOpts
    hostOpts
    hasHomeModule
    ;
}
