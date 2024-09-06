{ lib, ... }:

{
  services.xsettingsd = {
    enable = true;
  };

  xdg.configFile."xsettingsd".source = lib.outLink "xsettingsd";
}
