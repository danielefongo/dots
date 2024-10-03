{ pkgs, ... }:

let
  mkMisePackages = import ./package.nix { inherit pkgs; };

  packages = with pkgs; mkMisePackages {
    node = {
      version = "22.9.0";
      extraInstallPhase = "npm i -g yarn";
    };
    elm = { version = "0.19.1"; };
    lua = { version = "5.4.7"; buildInputs = [ unzip ]; };
    python = { version = "3.12.7"; };
    rust = { version = "1.81.0"; };
    elixir = { version = "1.17.3-otp-27"; buildInputs = [ unzip ]; };
    erlang = {
      version = "27.1.1";
      buildInputs = [ ncurses git perl openssl ];
      env = {
        KERL_CONFIGURE_OPTIONS = lib.concatStrings ([ "--without-javac " ]
          ++ [ "--with-ssl=${lib.getOutput "out" openssl} " ]
          ++ [ "--with-ssl-incl=${lib.getDev openssl}" ]);
      };
    };
    ruby = { version = "3.3.5"; buildInputs = [ libyaml ]; };
  };
in
{
  home.packages = [ pkgs.mise ] ++ packages;

  xdg.configFile."mise/config.toml".text = "";
}
