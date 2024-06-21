{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    firefoxWithUserJS
  ];

  home.file = {
    ".mozilla/firefox/profiles.ini".source = ./profile.ini;
    ".mozilla/firefox/default/.keep".text = "";
    ".mozilla/firefox/default/user.js".text = "";
  };
}
