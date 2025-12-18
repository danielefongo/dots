{ lib, pkgs, ... }:

{
  imports = with pkgs; [
    (lib.optionalPkg "apps._1password-gui" _1password-gui)
    (lib.optionalPkg "apps.rawtherapee" rawtherapee)
    (lib.optionalPkg "apps.pulseaudio" pulseaudio)
    (lib.optionalPkg "apps.pavucontrol" pavucontrol)
    (lib.optionalPkg "apps.peek" peek)
    (lib.optionalPkg "apps.spotify" spotify)
    (lib.optionalPkg "apps.telegram-desktop" telegram-desktop)
    (lib.optionalPkg "apps.wasistlos" wasistlos)
    (lib.optionalPkg "apps.ocr" ocr)
    (lib.optionalPkg "apps.deskflow" deskflow)
    (lib.optionalPkg "apps.qalculate-gtk" qalculate-gtk)
  ];
}
