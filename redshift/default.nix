{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    redshift
  ];

  xdg.configFile."redshift.conf".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/redshift/redshift.conf";

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