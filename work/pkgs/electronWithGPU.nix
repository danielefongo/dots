{ lib, pkgs, ... }:

let
  electronFlags = lib.concatStringsSep " " [
    "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
    "--disable-gpu-driver-bug-workarounds"
  ];
in
pkg:
pkgs.symlinkJoin {
  name = pkg.pname or pkg.name;
  paths = [ pkg ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --add-flags "${electronFlags}"
    done
  '';
}
