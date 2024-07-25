{ lib, pkgs, ... }:

let
  webApp = import ../package.nix { inherit pkgs lib; };
in
{
  home.packages = [
    (webApp {
      name = "WhatsApp";
      icon = ./icon.png;
      site = "https://web.whatsapp.com";
      userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0";
      css = lib.outFile "webapps/whatsapp/style.css";
    })
  ];
}
