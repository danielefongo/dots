{ pkgs, config, dots_path, ... }:

{
  imports = [ ./scripts.nix ];

  home.packages = with pkgs; [
    i3
    i3lock-fancy-rapid
  ];

  xdg.configFile."i3".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/i3";

  systemd.user.services = {
    i3 = {
      Unit = {
        Description = "i3 window manager";
        After = "xsession.target";
        Wants = "xsession.target";
      };
      Service = {
        Type = "notify";
        ExecStart = "${pkgs.i3}/bin/i3";
        ExecStopPost = "systemctl --user stop --no-block graphical-session.target";
      };
    };
  };

  systemd.user.targets = {
    i3-session = {
      Unit = {
        Description = "i3 session";
        BindsTo = "graphical-session.target";
        Wants = [
          "dunst.service"
          "flameshot.service"
          "picom.service"
          "polybar.service"
          "redshift.service"
          "wallpaper.service"
          "xsettingsd.service"
          "xbindkeys.service"
        ];
      };
    };
  };
}
