{ pkgs, home, config, dots_path, ... }:

{
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "gtk-theme";
    };
  };
}
