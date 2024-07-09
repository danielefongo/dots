{ pkgs, ... }:

{
  wrapNixGL = package: (
    pkgs.symlinkJoin {
      name = package.name;
      paths = [ package ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for full_path in $out/bin/*; do
          f=$(basename $full_path)
          rm $out/bin/$f
          echo "#!${pkgs.runtimeShell}" > $out/bin/$f
          echo "exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${package}/bin/$f" '"$@"' >> $out/bin/$f
          chmod +x $out/bin/$f
        done
      '';
    }
  );
}
