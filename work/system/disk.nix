{ dots_path, pkgs, ... }:

{
  systemd.services.secondary-disk = {
    enable = true;
    description = "Open secondary disk and mount /media/data";
    after = [ "systemd-udev-settle.service" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = [
      "!/dev/mapper/data"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "secondary-disk-mount" ''
        mkdir -p /media/data
        ${pkgs.cryptsetup}/bin/cryptsetup open /dev/disk/by-uuid/caf54dbc-9df5-42a5-b845-2b35acedcdc5 data --key-file=/root/.config/luks/luks.key
        ${pkgs.util-linux}/bin/mount /dev/mapper/data /media/data
      '';
    };
  };
}
