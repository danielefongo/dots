{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  environment.etc."ssl/certs/cloudflare.crt".source = ./certificate.crt;

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
