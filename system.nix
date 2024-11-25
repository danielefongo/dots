{ pkgs, ... }:
{
  imports = [ ./prima/system.nix ];

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
}
