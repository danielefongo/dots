{ lib, pkgs, ... }:

let
  webApp = import ../package.nix { inherit pkgs lib; };
in
{
  home.packages = [
    (webApp {
      name = "Slack";
      icon = ./icon.png;
      site = "https://app.slack.com/client/T024WK3NT";
      css = lib.outFile "webapps/slack/style.css";
    })
  ];
}
