{ pkgs, ... }:

let
  cpupower = pkgs.linuxKernel.packages.linux_latest_libre.cpupower;
in
{
  nixpkgs.hostPlatform = "x86_64-linux";

  systemd.services.dockerd = {
    enable = true;
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.docker}/bin/dockerd";
    };
    description = "Runs docker daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.nixdaemon = {
    enable = true;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nix}/bin/nix-daemon";
    };
    description = "Runs nix daemon";
    wantedBy = [ "multi-user.target" ];
  };

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

  environment.etc."pam.d/i3lock".text = ''
    auth       required   pam_unix.so
    account    required   pam_unix.so
    password   required   pam_unix.so
    session    required   pam_unix.so
  '';

  systemd.services.warp-svc = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
    };
    description = "Runs warp daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.tailscaled = {
    enable = true;
    description = "Tailscale node agent";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.tailscale}/bin/tailscaled";
    };
  };
}
