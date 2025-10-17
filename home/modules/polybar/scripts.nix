{ pkgs, ... }:

let
  cpu_temp = pkgs.writeShellScriptBin "cpu-temp" ''
    #!/usr/bin/env bash

    sensors="${pkgs.lm_sensors}/bin/sensors"

    cpu_temp=$($sensors | awk '/CPU:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
    if [ -z "$cpu_temp" ]; then
      cpu_temp=$($sensors | awk '/Package id 0:/ {gsub(/\+|°C/, "", $4); print int($4); exit}')
    fi
    if [ -z "$cpu_temp" ]; then
      cpu_temp=$($sensors | awk '/temp1:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
    fi

    if [ -z "$cpu_temp" ]; then
      echo "N/A"
      exit 1
    fi

    threshold="$1"
    ok_format=$(echo "$2" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
    warn_format=$(echo "$3" | sed -E 's/<([^>]+)>/{{ \1 }}/g')

    if [ -z "$threshold" ] || [ -z "$ok_format" ] || [ -z "$warn_format" ]; then
      echo "Usage: cpu-temp <threshold> <ok_format> <warn_format>"
      exit 1
    fi

    output=""

    if [ "$cpu_temp" -lt "$threshold" ]; then
      output="$ok_format"
    else
      output="$warn_format"
    fi

    echo "$output" | sed "s/{{ temp }}/$cpu_temp/g"
  '';

  mem_usage = pkgs.writeShellScriptBin "mem-usage" ''
    #!/usr/bin/env bash

    threshold="$1"
    ok_format=$(echo "$2" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
    warn_format=$(echo "$3" | sed -E 's/<([^>]+)>/{{ \1 }}/g')

    if [ -z "$threshold" ] || [ -z "$ok_format" ] || [ -z "$warn_format" ]; then
      echo "Usage: mem-usage <threshold_pct> <ok_format> <warn_format>"
      exit 1
    fi

    read total_kb used_kb pct < <(
      awk '
        BEGIN { mt=0; ma=0; st=0; sf=0 }
        $1=="MemTotal:"      { mt=$2 }
        $1=="MemAvailable:"  { ma=$2 }
        $1=="SwapTotal:"     { st=$2 }
        $1=="SwapFree:"      { sf=$2 }
        END {
          total = mt + st
          used  = (mt - ma) + (st - sf)
          if (total <= 0) total = 1
          pct = int((used * 100) / total)
          print total, used, pct
        }
      ' /proc/meminfo
    )

    used_h=$(awk -v kb="$used_kb"  'BEGIN { printf("%.1fGiB",  kb/1048576) }')
    total_h=$(awk -v kb="$total_kb" 'BEGIN { printf("%.1fGiB", kb/1048576) }')

    if [ "$pct" -lt "$threshold" ]; then
      output="$ok_format"
    else
      output="$warn_format"
    fi

    echo "$output" \
      | sed "s/{{ pct }}/$pct/g" \
      | sed "s/{{ used_kb }}/$used_kb/g" \
      | sed "s/{{ total_kb }}/$total_kb/g" \
      | sed "s/{{ used }}/$used_h/g" \
      | sed "s/{{ total }}/$total_h/g"
  '';
in
{
  home.packages = with pkgs; [
    cpu_temp
    mem_usage
  ];
}
