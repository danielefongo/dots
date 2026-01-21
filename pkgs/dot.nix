{
  inputs,
  user_data,
  pkgs,
  ...
}:

let
  dots_path = user_data.dots_path;
  hm = inputs.home-manager.lib.hm;

  mkOutOfStoreSymlink =
    path:
    let
      pathStr = toString path;
      name = hm.strings.storeFileName (baseNameOf pathStr);
    in
    pkgs.runCommandLocal name { } "ln -s ${pkgs.lib.escapeShellArg pathStr} $out";
in
{
  outLink = path: mkOutOfStoreSymlink "${dots_path}/output/${path}";
  outFile = path: "${dots_path}/output/${path}";

  link = path: mkOutOfStoreSymlink "${dots_path}/${path}";
  script =
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
