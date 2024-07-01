{ pkgs, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    dunst
  ];

  xdg.configFile."dunst".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/dunst";

  systemd.user.services = {
    dunst = {
      Unit = {
        Description = "Dunst";
      };

      Service = {
        ExecStart = "${pkgs.dunst}/bin/dunst";
        Restart = "always";
      };
    };
  };
}
