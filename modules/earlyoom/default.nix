{ pkgs, ... }:

{
  home.packages = with pkgs; [ earlyoom ];

  systemd.user.services = {
    earlyoom = {
      Unit = {
        Description = "Early OOM";
      };

      Service = {
        ExecStart = "${pkgs.earlyoom}/bin/earlyoom";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
