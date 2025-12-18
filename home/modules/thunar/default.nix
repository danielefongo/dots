{ lib, pkgs, ... }:

lib.optionalModule "apps.thunar" { } (cfg: {
  home.packages = with pkgs.xfce; [
    thunar
    tumbler
  ];

  systemd.user.services.tumblerd = {
    Unit = {
      Description = "Tumbler thumbnailing service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.thumbnails.Thumbnailer1";
      ExecStart = "${pkgs.xfce.tumbler}/lib/tumbler-1/tumblerd";
      Restart = "on-failure";
      RestartSec = 2;
      Environment = "XDG_CACHE_HOME=%h/.cache";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  targets.genericLinux.enable = true;
})
