{ pkgs, ... }:

{
  home.packages = [ pkgs.nix-theme ];

  systemd.user.services = {
    theme = {
      Unit = {
        Description = "Theme";
      };

      Service = {
        ExecStart = "${pkgs.nix-theme}/bin/nix-theme watch";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
