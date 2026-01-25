#!/usr/bin/env bash

cpu_temp=$(sensors | awk '/CPU:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
if [ -z "$cpu_temp" ]; then
  cpu_temp=$(sensors | awk '/Package id 0:/ {gsub(/\+|°C/, "", $4); print int($4); exit}')
fi
if [ -z "$cpu_temp" ]; then
  cpu_temp=$(sensors | awk '/temp1:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
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

echo "${output//\{\{ temp \}\}/$cpu_temp}"
