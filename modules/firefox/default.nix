{ lib, pkgs, ... }:

let
  userJS = lib.outLink "firefox/user.js";
  chromeCSS = lib.outLink "firefox/chrome";
  firefoxWithUserJS = import ./package.nix { inherit pkgs lib; };
in
{
  home.packages = [
    (firefoxWithUserJS [ "personal" "work" ])
  ];

  home.file = {
    ".mozilla/firefox/profiles.ini".text = ''
      [General]
      StartWithLastProfile=1

      [Profile0]
      Default=0
      IsRelative=1
      Name=personal
      Path=personal

      [Profile1]
      Default=1
      IsRelative=1
      Name=work
      Path=work
    '';
    ".mozilla/firefox/personal/.keep".text = "";
    ".mozilla/firefox/personal/user.js".source = userJS;
    ".mozilla/firefox/personal/chrome".source = chromeCSS;
    ".mozilla/firefox/work/.keep".text = "";
    ".mozilla/firefox/work/user.js".source = userJS;
    ".mozilla/firefox/work/chrome".source = chromeCSS;
  };
}
