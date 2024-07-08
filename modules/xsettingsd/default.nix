{ ... }:

{
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "gtk-theme";
    };
  };
}
