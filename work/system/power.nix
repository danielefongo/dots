{ dots_path, pkgs, ... }:

let
  this_path = "${dots_path}/work/system/";
in
{
  systemd.services.auto-cpufreq = {
    enable = true;
    description = "auto-cpufreq - Automatic CPU speed & power optimizer";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "auto-cpufreq-watcher.path" ];
    path = [
      pkgs.bash
      pkgs.coreutils
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.auto-cpufreq}/bin/auto-cpufreq --daemon --config ${this_path}/auto-cpufreq.conf";
      Restart = "on-failure";
    };
  };

  systemd.paths.auto-cpufreq-watcher = {
    enable = true;
    description = "Watch auto-cpufreq config for changes";
    pathConfig = {
      PathModified = "${this_path}/auto-cpufreq.conf";
      Unit = "auto-cpufreq-reload.service";
    };
  };

  systemd.services.auto-cpufreq-reload = {
    enable = true;
    description = "Restart auto-cpufreq on config change";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart auto-cpufreq";
    };
  };
}
