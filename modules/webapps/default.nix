{ lib, pkgs, ... }:

let
  webApp = import ./package.nix { inherit pkgs lib; };
  firefoxUserAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0";
in
{
  home.packages = [
    (webApp {
      name = "Netflix";
      site = "https://www.netflix.com";
      icon =
        (pkgs.fetchurl {
          url = "https://img.icons8.com/color/480/netflix.png";
          sha256 = "sha256-3L1asm7dLDLA6CQhuFpzUxDzhTj3Du2/M8K6KLA+ryM=";
        }).outPath;
      userAgent = firefoxUserAgent;
    })
  ];
}
