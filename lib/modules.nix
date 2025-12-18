{ pkgs, ... }:

with pkgs.lib;
let
  modulesIn = (
    dir:
    pipe dir [
      builtins.readDir
      (mapAttrsToList (
        name: type:
        if type == "regular" && hasSuffix ".nix" name && name != "default.nix" then
          [
            {
              name = removeSuffix ".nix" name;
              value = dir + "/${name}";
            }
          ]
        else if type == "directory" && pathExists (dir + "/${name}/default.nix") then
          [
            {
              inherit name;
              value = dir + "/${name}";
            }
          ]
        else
          [ ]
      ))
      concatLists
      listToAttrs
    ]
  );

  optionalModule = name: paramSpec: moduleConfigFn: {
    imports = [
      (
        {
          config,
          lib,
          ...
        }:
        let
          modulePath = [ "module" ] ++ (lib.splitString "." name);
          makeOptions = lib.mapAttrs (
            paramName: paramDef:
            lib.mkOption {
              type = paramDef.type;
              description = paramDef.description or "";
            }
            // (lib.optionalAttrs (paramDef ? default) { default = paramDef.default; })
          ) paramSpec;
          moduleOptions = {
            enable = lib.mkEnableOption name;
          }
          // makeOptions;
        in
        {
          imports = (moduleConfigFn { }).imports or [ ];
          options = lib.setAttrByPath modulePath (
            lib.mkOption {
              type = lib.types.submodule {
                options = moduleOptions;
                freeformType = lib.types.attrs;
              };
              default = { };
            }
          );
          config =
            let
              moduleConfig = lib.attrByPath modulePath null config;
              enabled = if moduleConfig == null then false else moduleConfig.enable or false;
              params = if enabled then (lib.filterAttrs (k: v: k != "enable") moduleConfig) else { };
              configWithParams = moduleConfigFn params;
              configWithNoImports = lib.attrsets.removeAttrs configWithParams [ "imports" ];
            in
            lib.mkIf enabled configWithNoImports;
        }
      )
    ];
  };

  optionalPkg =
    path: pkg:
    optionalModule path { } (cfg: {
      home.packages = [ pkg ];
    });
in
{
  inherit
    modulesIn
    optionalModule
    optionalPkg
    ;
}
