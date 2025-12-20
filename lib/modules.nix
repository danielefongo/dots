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

  withCfg = name: paramSpec: moduleConfigFn: {
    imports = [
      (
        {
          config,
          lib,
          ...
        }:
        let
          modulePath = [ "cfg" ] ++ (lib.splitString "." name);
          makeOptions = lib.mapAttrs (
            paramName: paramDef:
            lib.mkOption {
              type = paramDef.type;
              description = paramDef.description or "";
            }
            // (lib.optionalAttrs (paramDef ? default) { default = paramDef.default; })
          ) paramSpec;
        in
        {
          imports = (moduleConfigFn { }).imports or [ ];
          options = lib.setAttrByPath modulePath (
            lib.mkOption {
              type = lib.types.submodule {
                options = makeOptions;
                freeformType = lib.types.attrs;
              };
            }
          );
          config =
            let
              moduleConfig = lib.attrByPath modulePath { } config;
              params = moduleConfig;
              configWithParams = moduleConfigFn params;
              configWithNoImports = lib.attrsets.removeAttrs configWithParams [ "imports" ];
            in
            configWithNoImports;
        }
      )
    ];
  };
in
{
  inherit
    modulesIn
    withCfg
    ;
}
