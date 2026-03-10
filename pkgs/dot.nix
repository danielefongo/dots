{
  inputs,
  dots_path,
  pkgs,
  ...
}:

final: prev:
let
  hm = inputs.home-manager.lib.hm;

  mkOutOfStoreSymlink =
    path:
    let
      pathStr = toString path;
      name = hm.strings.storeFileName (baseNameOf pathStr);
    in
    prev.runCommandLocal name { } "ln -s ${prev.lib.escapeShellArg pathStr} $out";
in
{
  dot = {
    outLink = path: mkOutOfStoreSymlink "${dots_path}/output/${path}";
    outFile = path: "${dots_path}/output/${path}";

    link = path: mkOutOfStoreSymlink "${dots_path}/${path}";
    script =
      name: source: deps:
      let
        content = if builtins.isPath source then builtins.readFile source else "bash ${source}";
      in
      prev.writeShellApplication {
        inherit name;
        runtimeInputs = deps;
        excludeShellChecks = [ "SC2016" ];
        text = ''
          #!${prev.runtimeShell}
          set -eo pipefail
          export DOTS_PATH="${dots_path}"
          : $DOTS_PATH
          ${content}
        '';
      };
  };
}
