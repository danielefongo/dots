{
  inputs,
  dots_path,
  pkgs,
  ...
}:

let
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
  relativeLink = dir: path: mkOutOfStoreSymlink "${toString dir}/${path}";
  script =
    name: source: deps:
    let
      content = if builtins.isPath source then builtins.readFile source else "bash ${source}";
    in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = deps;
      excludeShellChecks = [ "SC2016" ];
      text = ''
        #!${pkgs.runtimeShell}
        set -eo pipefail
        export DOTS_PATH="${dots_path}"
        : $DOTS_PATH
        ${content}
      '';
    };
}
