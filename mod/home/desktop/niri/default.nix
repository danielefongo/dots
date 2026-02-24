{ lib, pkgs, ... }:

lib.homeOpts.module "desktop.niri" { } (_: {
  home.packages = with pkgs; [
    niri
    wl-clipboard
    (pkgs.dot.script "niri-lock" (pkgs.dot.outLink "niri/lock.sh") [ swaylock-effects ])
  ];

  xdg.configFile."niri".source = pkgs.dot.outLink "niri";

  systemd.user.targets.wayland-session = {
    Unit = {
      Description = "niri session";
      BindsTo = "graphical-session.target";
      Wants = [ ];
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland Satellite";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.lock-handler = {
    Unit = {
      Description = "Lock screen on loginctl lock-session";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "lock-handler" ''
        ${pkgs.dbus}/bin/dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Session',member='Lock'" | while read -r line; do
          if echo "$line" | ${pkgs.gnugrep}/bin/grep -q "member=Lock"; then
            niri-lock
          fi
        done
      '';
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  services.polkit-gnome.enable = true;

  mod.home.apps.audio.enable = true;
  mod.home.apps.copyq.enable = true;
  mod.home.desktop.flameshot.enable = true;
  mod.home.desktop.playerctl.enable = true;
  mod.home.system.theme.enable = true;
  mod.home.terminal.kitty.enable = true;
})
