{
  config,
  lib,
  pkgs,
  ...
}:

let
  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";
in
lib.homeOpts.module "apps.copyq" { } (_: {
  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."copyq/copyq.conf".source = pkgs.dot.outLink "copyq/copyq.conf";

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ";
      PartOf = [ sessionTarget ];
    };

    Install = {
      WantedBy = [ sessionTarget ];
    };

    Service = (
      {
        Type = "forking";
        ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
        Restart = "always";
        RestartSec = 2;
      }
      // lib.optionalAttrs isWayland {
        Environment = "QT_QPA_PLATFORM=wayland";
      }
    );
  };
})
