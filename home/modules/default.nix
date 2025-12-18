{ lib, ... }:

{
  imports = [
    ./apps
    ./btop
    ./copyq
    ./discord
    ./docker
    ./dunst
    ./essentials
    ./firefox
    ./flameshot
    ./fonts
    ./fzf
    ./git
    ./gtk
    ./i3
    ./kitty
    ./nix
    ./nix-theme
    ./nvim
    ./others
    ./picom
    ./playerctl
    ./plover
    ./polybar
    ./redshift
    ./rofi
    ./sesh
    ./shell-utils
    ./thunar
    ./tig
    ./tmux
    ./wallpaper
    ./xbindkeys
    ./xsettingsd
    ./zsh
    (lib.optionalModule "apps.full"
      {
        firefox = {
          type = lib.types.attrs;
        };
      }
      (cfg: {
        module.apps._1password-gui.enable = true;
        module.apps.rawtherapee.enable = true;
        module.apps.pulseaudio.enable = true;
        module.apps.pavucontrol.enable = true;
        module.apps.peek.enable = true;
        module.apps.spotify.enable = true;
        module.apps.telegram-desktop.enable = true;
        module.apps.wasistlos.enable = true;
        module.apps.ocr.enable = true;
        module.apps.deskflow.enable = true;
        module.apps.qalculate-gtk.enable = true;

        module.apps.kitty.enable = true;
        module.apps.copyq.enable = true;
        module.apps.discord.enable = true;
        module.apps.plover.enable = true;
        module.apps.thunar.enable = true;
        module.apps.firefox = {
          enable = true;
          profiles = cfg.firefox.profiles;
        };
      })
    )
    (lib.optionalModule "shell.full" { } (cfg: {
      module.shell.btop.enable = true;
      module.shell.fzf.enable = true;
      module.shell.git.enable = true;
      module.shell.nvim.enable = true;
      module.shell.tig.enable = true;
      module.shell.utils.enable = true;
      module.shell.zsh.enable = true;
    }))
    (lib.optionalModule "i3" { } (cfg: {
      module.x11.flameshot.enable = true;
      module.x11.i3.enable = true;
      module.x11.dunst.enable = true;
      module.x11.picom.enable = true;
      module.x11.polybar.enable = true;
      module.x11.redshift.enable = true;
      module.x11.rofi.enable = true;
      module.x11.wallpaper.enable = true;
      module.x11.xbindkeys.enable = true;
      module.x11.xsettingsd.enable = true;
    }))
    (lib.optionalModule "terminal.full" { } (cfg: {
      module.terminal.sesh.enable = true;
      module.terminal.tmux.enable = true;
    }))
  ];
}
