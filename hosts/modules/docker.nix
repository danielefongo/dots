{ ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
