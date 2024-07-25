{ lib, pkgs, ... }:

let
  webApp = import ../package.nix { inherit pkgs lib; };
in
{
  home.packages = [
    (webApp {
      name = "Telegram";
      icon = ./icon.png;
      site = "https://web.telegram.org";
      css = lib.outFile "webapps/telegram/style.css";
    })
  ];
}
