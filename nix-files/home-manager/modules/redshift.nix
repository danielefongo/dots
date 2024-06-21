{ pkgs, home, ... }:

{
  home.packages = with pkgs; [
    redshift
  ];

  systemd.user.services = {
    redshift = {
      Unit = {
        Description = "Redshift";
      };

      Service = {
        ExecStart = "${pkgs.redshift}/bin/redshift";
        Restart = "always";
      };
    };
  };
}
