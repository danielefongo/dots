{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    dunst
  ];

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
