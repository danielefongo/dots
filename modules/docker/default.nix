{ pkgs, ... }:

let
  dockerWrapper = pkgs.writeShellScriptBin "docker" ''
    export DOCKER_HOST="unix:///run/user/$(id --user)/docker.sock"
    ${pkgs.docker}/bin/docker "$@"
  '';
in
{
  home.packages = with pkgs; [
    dockerWrapper # on ubuntu you need to install uidmap
  ];

  systemd.user.services = {
    dockerd = {
      Unit = {
        Description = "Docker rootless";
      };

      Service = {
        ExecStart = "${pkgs.docker}/bin/dockerd-rootless";
        Restart = "on-failure";
      };
    };
  };
}
