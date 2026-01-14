#!/usr/bin/env bash

threshold="$1"
ok_format=$(echo "$2" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
warn_format=$(echo "$3" | sed -E 's/<([^>]+)>/{{ \1 }}/g')

if [ -z "$threshold" ] || [ -z "$ok_format" ] || [ -z "$warn_format" ]; then
  echo "Usage: mem-usage <threshold_pct> <ok_format> <warn_format>"
  exit 1
fi

read -r total_kb used_kb pct < <(
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

used_h=$(awk -v kb="$used_kb" 'BEGIN { printf("%.1fGiB",  kb/1048576) }')
total_h=$(awk -v kb="$total_kb" 'BEGIN { printf("%.1fGiB", kb/1048576) }')

if [ "$pct" -lt "$threshold" ]; then
  output="$ok_format"
else
  output="$warn_format"
fi

output="${output//\{\{ pct \}\}/$pct}"
output="${output//\{\{ used_kb \}\}/$used_kb}"
output="${output//\{\{ total_kb \}\}/$total_kb}"
output="${output//\{\{ used \}\}/$used_h}"
output="${output//\{\{ total \}\}/$total_h}"

echo "$output"
