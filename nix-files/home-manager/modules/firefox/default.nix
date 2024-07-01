{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    firefoxWithUserJS
  ];

  home.file = {
    ".mozilla/firefox/profiles.ini".source = ./profile.ini;
    ".mozilla/firefox/default/.keep".text = "";
    ".mozilla/firefox/default/user.js".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/firefox/user.js";
    ".mozilla/firefox/default/chrome".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/firefox/chrome";
  };
}
