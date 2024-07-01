{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    sassc
  ];

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "gtk-theme";
    };
  };
}
