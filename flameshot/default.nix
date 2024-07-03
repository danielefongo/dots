{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    flameshot
  ];

  xdg.configFile."flameshot".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/flameshot";

  systemd.user.services = {
    flameshot = {
      Unit = {
        Description = "Flameshot";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-failure";
      };
    };
  };
}
