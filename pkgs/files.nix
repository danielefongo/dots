{ user_data, pkgs, ... }:

let
  dots_path = user_data.dots_path;

  mkOutOfStoreSymlink =
    path:
    let
      pathStr = toString path;
      name = pkgs.lib.hm.strings.storeFileName (baseNameOf pathStr);
    in
    pkgs.runCommandLocal name { } "ln -s ${pkgs.lib.escapeShellArg pathStr} $out";
in
{
  outLink = path: mkOutOfStoreSymlink "${dots_path}/output/${path}";
  dotLink = path: mkOutOfStoreSymlink "${dots_path}/${path}";
  outFile = path: "${dots_path}/output/${path}";
}
