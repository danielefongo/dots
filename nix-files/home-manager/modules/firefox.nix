{ pkgs, home, config, dots_path, ... }:

let
  firefoxJs = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/firefox/user.js";
  firefoxChromeCss = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/firefox/chrome";
in
{
  home.packages = with pkgs; [
    (firefoxWithUserJS ["personal" "work"])
  ];

  home.file = {
    ".mozilla/firefox/profiles.ini".text = ''
      [General]
      StartWithLastProfile=1

      [Profile0]
      Default=1
      IsRelative=1
      Name=personal
      Path=personal

      [Profile1]
      Default=0
      IsRelative=1
      Name=work
      Path=work
    '';
    ".mozilla/firefox/personal/.keep".text = "";
    ".mozilla/firefox/personal/user.js".source = firefoxJs;
    ".mozilla/firefox/personal/chrome".source = firefoxChromeCss;
    ".mozilla/firefox/work/.keep".text = "";
    ".mozilla/firefox/work/user.js".source = firefoxJs;
    ".mozilla/firefox/work/chrome".source = firefoxChromeCss;
  };
}
