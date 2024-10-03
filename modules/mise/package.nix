{ pkgs, ... }:

let
  mkMisePackage = { name, version ? "latest", buildInputs ? [ ], env ? { } }:
    with pkgs; stdenv.mkDerivation ({
      pname = name;
      version = version;
      src = runCommand "empty" { } "mkdir -p $out";
      buildInputs = [ curl ] ++ buildInputs;
      installPhase = ''
        export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
        MISE_VERBOSE=1 HOME=$out ${mise}/bin/mise install ${name}@${version} -y
        mkdir -p $out/${name}/bin
        cp -r $out/.local/share/mise/installs/${name}/${version}/* $out/${name}/
        mkdir -p $out/bin
        for file in $out/${name}/bin/*; do
          ln -s ../${name}/bin/$(basename $file) $out/bin/$(basename $file)
        done
      '';
    } // env);

  mkMisePackages = packages: map (name: mkMisePackage ({ name = name; } // packages.${name})) (builtins.attrNames packages);
in
mkMisePackages
