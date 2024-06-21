{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    picom
  ];

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
      };

      Service = {
        ExecStart = "${pkgs.picom}/bin/picom";
        Restart = "always";
      };
    };
  };
}
