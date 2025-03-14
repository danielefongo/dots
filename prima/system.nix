{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

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
