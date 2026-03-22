{
  pkgs,
  lib,
  ...
}:
let
  mkSecret =
    file: format: _: val:
    if builtins.isString val then
      {
        sopsFile = file;
        path = val;
        inherit format;
      }
    else
      {
        sopsFile = file;
        inherit format;
      }
      // val;

  mkSecrets =
    {
      file,
      format,
      entries,
    }:
    builtins.mapAttrs (mkSecret file format) entries;

  opts = {
    secrets = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            file = lib.mkOption { type = lib.types.path; };
            format = lib.mkOption {
              type = lib.types.enum [
                "yaml"
                "json"
                "binary"
                "ini"
                "dotenv"
              ];
              default = "yaml";
            };
            entries = lib.mkOption { type = lib.types.attrs; };
          };
        }
      );
      default = { };
    };
    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      default = ./secrets.yaml;
    };
  };
in
lib.homeOpts.module "secrets" opts (
  { config, moduleConfig, ... }:
  let
    home = config.home.homeDirectory;
    resolvedSecrets = lib.foldl' lib.mergeAttrs { } (
      map mkSecrets (builtins.attrValues moduleConfig.secrets)
    );
    prefixHome = _: secret: secret // { path = "${home}/${secret.path}"; };
    finalSecrets = builtins.mapAttrs prefixHome resolvedSecrets;
  in
  {
    home.packages = [
      pkgs.age
      pkgs.sops
    ];
    sops = {
      age.keyFile = "${home}/.config/sops/age/keys.txt";
      age.sshKeyPaths = [ ];
      defaultSopsFile = moduleConfig.defaultSopsFile;
      validateSopsFiles = true;
      secrets = lib.optionalAttrs (config.mod.home.secrets.enable == true) finalSecrets;
    };
  }
)
