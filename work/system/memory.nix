{ pkgs, ... }:

{
  systemd.services.earlyoom = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.earlyoom}/bin/earlyoom";
    };
    description = "Runs earlyOOM daemon";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.bigswap = {
    enable = true;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "bigswap" ''
        swapfile="/bigswap"
        if [[ ! -f $swapfile ]]; then
          ${pkgs.util-linux}/bin/fallocate -l 32G $swapfile
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
