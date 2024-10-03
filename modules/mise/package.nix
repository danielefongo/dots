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
        for dir in bin lib share include; do
          if [ -d $out/.local/share/mise/installs/${name}/${version}/$dir ]; then
            mkdir -p $out/$dir
            cp -r $out/.local/share/mise/installs/${name}/${version}/$dir/* $out/$dir/
          fi
        done
      '';
    } // env);

  mkMisePackages = packages: map (name: mkMisePackage ({ name = name; } // packages.${name})) (builtins.attrNames packages);
in
mkMisePackages
