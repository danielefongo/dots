{ lib, pkgs, ... }:

let
  webApp = import ./package.nix { inherit pkgs lib; };
  userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0";
in
{
  home.packages = [
    (webApp {
      name = "Slack";
      site = "https://app.slack.com/client/T024WK3NT";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color-glass/480/slack-new.png";
        sha256 = "sha256-O7C1z66smLZShfgUw1L3rXCgb/TgRqLqOv7vgEQAei4=";
      }).outPath;
      userAgent = userAgent;
    })
    (webApp {
      name = "Telegram";
      site = "https://web.telegram.org";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/480/telegram-app--v1.png";
        sha256 = "sha256-Wg/jU2cGcLl7WJCDOvld0KjwSfByiFSXsZkUM/J43GU=";
      }).outPath;
      css = lib.outFile "webapps/style/telegram.css";
      userAgent = userAgent;
    })
    (webApp {
      name = "WhatsApp";
      site = "https://web.whatsapp.com";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/480/whatsapp--v1.png";
        sha256 = "sha256-b7D6VTLW/X/To1iSG0++ydGaU2WS91+6M48oY2arYL0=";
      }).outPath;
      userAgent = userAgent;
    })
  ];
}
