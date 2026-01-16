{ pkgs, ... }:

with pkgs.lib;
let
  modulesIn = (
    dir:
    pipe dir [
      builtins.readDir
      (mapAttrsToList (
        name: type:
        if
          type == "regular" && hasSuffix ".nix" name && name != "default.nix" && !(hasSuffix "_test.nix" name)
        then
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

  mkModule =
    {
      pathPrefix,
      name,
      opts,
      moduleFn,
      enableOption ? false,
    }:
    {
      imports = [
        (
          { config, lib, ... }:
          let
            emptyConfig = { };
            modulePath = pathPrefix ++ lib.splitString "." name;

            optionConfig = lib.mkOption {
              default = emptyConfig;
              type = lib.types.submodule {
                options =
                  (lib.optionalAttrs enableOption {
                    enable = lib.mkOption {
                      type = lib.types.nullOr lib.types.bool;
                      default = null;
                      description = "Whether to enable ${name}. Null means inherit from parent.";
                    };
                  })
                  // (lib.mapAttrs (
                    _: paramDef:
                    lib.mkOption {
                      type = paramDef.type;
                      description = paramDef.description or "";
                    }
                    // lib.optionalAttrs (paramDef ? default) { default = paramDef.default; }
                  ) opts);
              };
            };

            isParentExplicitlyEnabled =
              path:
              let
                atRoot = lib.length path <= lib.length pathPrefix;
                parentPath = lib.init path;
                parentCfg = lib.attrByPath parentPath null config;
                parentEnabled = parentCfg.enable or null;
              in
              !atRoot
              && (parentEnabled == true || (parentEnabled != false && isParentExplicitlyEnabled parentPath));

            isAnyParentExplicitlyDisabled =
              path:
              let
                atRoot = lib.length path <= lib.length pathPrefix;
                parentPath = lib.init path;
                parentCfg = lib.attrByPath parentPath null config;
                parentEnabled = parentCfg.enable or null;
              in
              !atRoot && (parentEnabled == false || isAnyParentExplicitlyDisabled parentPath);
          in
          {
            imports = (moduleFn emptyConfig).imports or [ ];
            options = lib.setAttrByPath modulePath optionConfig;

            config =
              let
                moduleCfg = lib.attrByPath modulePath emptyConfig config;
                enableVal = moduleCfg.enable or null;

                enabled =
                  if enableVal == false then
                    false
                  else if isAnyParentExplicitlyDisabled modulePath then
                    false
                  else if isParentExplicitlyEnabled modulePath then
                    true
                  else
                    !enableOption || enableVal == true;

                params = lib.filterAttrs (k: v: k != "enable" && !(lib.isAttrs v && v ? enable)) moduleCfg;

                result = moduleFn (if enabled then params else emptyConfig);
                finalCfg = lib.removeAttrs result [ "imports" ];

                moduleSettings =
                  if finalCfg ? ${builtins.head pathPrefix} then
                    { ${builtins.head pathPrefix} = finalCfg.${builtins.head pathPrefix}; }
                  else
                    { };

                otherSettings = lib.removeAttrs finalCfg (lib.singleton (builtins.head pathPrefix));
              in
              lib.mkMerge [
                moduleSettings
                (lib.mkIf (enableOption -> enabled) otherSettings)
              ];
          }
        )
      ];
    };

  withCfg =
    name: opts: moduleFn:
    mkModule {
      inherit name opts moduleFn;
      pathPrefix = [ "cfg" ];
      enableOption = false;
    };

  optionalModule =
    name: opts: moduleFn:
    mkModule {
      inherit name opts moduleFn;
      pathPrefix = [ "module" ];
      enableOption = true;
    };

  optionalHomePkg =
    path: pkg:
    optionalModule path { } (cfg: {
      home.packages = [ pkg ];
    });

  optionalBundle = path: modulePaths: {
    imports = [
      (optionalModule path { } (cfg: { }))
      (
        { config, lib, ... }:
        {
          config = lib.mkMerge (
            map (
              modulePath:
              let
                bundlePath = [ "module" ] ++ lib.splitString "." path;
                fullModulePath = [ "module" ] ++ lib.splitString "." modulePath;
                bundleCfg = lib.attrByPath bundlePath { } config;
                bundleEnabled = bundleCfg.enable or null;
              in
              lib.setAttrByPath fullModulePath {
                enable =
                  if bundleEnabled == true then
                    lib.mkDefault true
                  else if bundleEnabled == false then
                    lib.mkOverride 75 false
                  else
                    lib.mkDefault null;
              }
            ) modulePaths
          );
        }
      )
    ];
  };
in
{
  inherit
    modulesIn
    optionalModule
    optionalHomePkg
    optionalBundle
    withCfg
    ;
}
