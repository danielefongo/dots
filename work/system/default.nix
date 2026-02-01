{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ./memory.nix
    ./power.nix
  ];

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

  environment.etc."pam.d/i3lock".text = ''
    auth       sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=/etc/u2f_keys
    auth       required   pam_unix.so
    account    required   pam_unix.so
    password   required   pam_unix.so
    session    required   pam_unix.so
  '';

  systemd.services.pcsclite = {
    enable = true;
    description = "PC/SC Smart Card Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      PCSCLITE_HP_DROPDIR = "${pkgs.ccid}/pcsc/drivers";
    };

    serviceConfig = {
      ExecStart = "${pkgs.pcsclite}/bin/pcscd -f -d";
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

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
