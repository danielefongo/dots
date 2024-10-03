{ pkgs, ... }:

let
  mkMisePackage = import ./package.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    mise
    (mkMisePackage { name = "node"; version = "22.9.0"; })
    (mkMisePackage { name = "elm"; version = "0.19.1"; })
    (mkMisePackage { name = "lua"; version = "5.4.7"; buildInputs = [ unzip ]; })
    (mkMisePackage { name = "python"; version = "3.12.7"; })
    (mkMisePackage { name = "rust"; version = "1.81.0"; })
    (mkMisePackage { name = "elixir"; version = "1.17.3-otp-27"; buildInputs = [ unzip ]; })
    (mkMisePackage {
      name = "erlang";
      version = "27.1.1";
      buildInputs = [ ncurses git perl openssl ];
      env = {
        KERL_CONFIGURE_OPTIONS = lib.concatStrings ([ "--without-javac " ]
          ++ [ "--with-ssl=${lib.getOutput "out" openssl} " ]
          ++ [ "--with-ssl-incl=${lib.getDev openssl}" ]);
      };
    })
    (mkMisePackage { name = "ruby"; version = "3.3.5"; buildInputs = [ libyaml ]; })
  ];

  xdg.configFile."mise/config.toml".text = "";
}
