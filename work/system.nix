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
}
