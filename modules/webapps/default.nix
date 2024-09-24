{ lib, pkgs, ... }:

let
  webApp = import ./package.nix { inherit pkgs lib; };
  chromeUserAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36";
  firefoxUserAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0";
in
{
  home.packages = [
    (webApp {
      name = "Slack";
      site = "https://app.slack.com/client/T024WK3NT";
      protocol = "slack";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color-glass/480/slack-new.png";
        sha256 = "sha256-O7C1z66smLZShfgUw1L3rXCgb/TgRqLqOv7vgEQAei4=";
      }).outPath;
      userAgent = chromeUserAgent;
      uriParser = ''(uri) => {
        const parsedUrl = new URL(uri);
        const params = new URLSearchParams(parsedUrl.search);
        let newUrl = `https://app.slack.com/client/''${params.get("team")}/''${params.get("id")}`;
        if (params.has("message")) {
          newUrl += `/''${params.get("message")}`;
        }
        return newUrl;
      }'';
      notification = "true";
    })
    (webApp {
      name = "Telegram";
      site = "https://web.telegram.org";
      configFolder = "AppTelegram";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/480/telegram-app--v1.png";
        sha256 = "sha256-Wg/jU2cGcLl7WJCDOvld0KjwSfByiFSXsZkUM/J43GU=";
      }).outPath;
      css = lib.outFile "webapps/style/telegram.css";
      userAgent = chromeUserAgent;
    })
    (webApp {
      name = "WhatsApp";
      site = "https://web.whatsapp.com";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/480/whatsapp--v1.png";
        sha256 = "sha256-b7D6VTLW/X/To1iSG0++ydGaU2WS91+6M48oY2arYL0=";
      }).outPath;
      userAgent = chromeUserAgent;
    })
    (webApp {
      name = "Spotify";
      site = "https://spotify.com/";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/fluency/240/spotify.png";
        sha256 = "sha256-vYs3+sJDxedD3BOMPeMDsUX2f42NIe8gHjTdPUXb35s=";
      }).outPath;
      music = lib.outFile "webapps/music/spotify.js";
      userAgent = chromeUserAgent;
    })
    (webApp {
      name = "Netflix";
      site = "https://www.netflix.com";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/480/netflix.png";
        sha256 = "sha256-3L1asm7dLDLA6CQhuFpzUxDzhTj3Du2/M8K6KLA+ryM=";
      }).outPath;
      userAgent = firefoxUserAgent;
    })
  ];
}
