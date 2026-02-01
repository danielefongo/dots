{ user_data, pkgs, ... }:

let
  this_path = "${user_data.dots_path}/work/system/";
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

  systemd.services.ananicy = {
    enable = true;
    description = "ananicy - automatic process nice daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "ananicy-watcher.path" ];
    path = [
      pkgs.gawk
    ];
    environment = {
      ANANICY_CPP_CONFDIR = "${this_path}/ananicy";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ananicy-cpp}/bin/ananicy-cpp start";
      ExecStartPost = "${pkgs.bash}/bin/bash ${this_path}/ananicy/create-cgroups.sh";
      ExecReload = "${pkgs.ananicy-cpp}/bin/ananicy-cpp --reload";
      Restart = "on-failure";
    };
  };

  systemd.paths.ananicy-watcher = {
    enable = true;
    description = "Watch ananicy config for changes";
    pathConfig = {
      PathChanged = "${this_path}/ananicy";
      Unit = "ananicy-reload.service";
    };
  };

  systemd.services.ananicy-reload = {
    enable = true;
    description = "Restart ananicy on config change";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart ananicy";
    };
  };
}
