{ pkgs, ... }:

{
  systemd.services.earlyoom = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.earlyoom}/bin/earlyoom";
    };
    description = "Runs earlyOOM daemon";
    after = [ "secondary-disk.service" ];
    requires = [ "secondary-disk.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.swap = {
    enable = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "swap" ''
        swapfile="/media/data/swap"
        if [[ ! -f $swapfile ]]; then
          ${pkgs.util-linux}/bin/fallocate -l 16G $swapfile
          ${pkgs.util-linux}/bin/mkswap $swapfile
          ${pkgs.coreutils}/bin/chmod 600 $swapfile
        fi
        ${pkgs.util-linux}/bin/swapon $swapfile
      ''}";
    };
    description = "Ensures 32GB swap file is created and enabled";
    wantedBy = [ "multi-user.target" ];
  };

}
