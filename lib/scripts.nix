{ pkgs, user_data, ... }:

{
  dotScript =
    name: file: deps:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = deps;
      text = ''
        #!${pkgs.runtimeShell}
        set -eo pipefail
        export DOTS_PATH="${user_data.dots_path}"
        export USER="${user_data.user}"
        : $DOTS_PATH
        : $USER
        ${builtins.readFile file}
      '';
    };
}
