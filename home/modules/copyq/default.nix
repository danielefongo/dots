{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."copyq/copyq.conf".source = lib.outLink "copyq/copyq.conf";

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ Clipboard Manager (server)";
      PartOf = [ "i3-session.target" ];
      After = [ "i3-session.target" ];
    };

    Install = {
      WantedBy = [ "i3-session.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
      ExecStop = "${pkgs.copyq}/bin/copyq exit";
    };
  };
}
