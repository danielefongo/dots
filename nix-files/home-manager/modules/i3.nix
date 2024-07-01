{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    i3
    i3lock-fancy-rapid
    rofi
    flameshot
  ];

  xdg.configFile."i3".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/i3";
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/rofi";

  systemd.user.targets = {
    i3-session = {
      Unit = {
        Description = "i3 session";
        BindsTo = "graphical-session.target";
        Wants = [
          "polybar.service"
          "picom.service"
          "wallpaper.service"
          "redshift.service"
          "xsettingsd.service"
          "theme.service"
        ];
      };
    };
  };
}
