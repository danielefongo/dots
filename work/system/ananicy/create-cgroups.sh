#!/usr/bin/env bash

values=(0.05 0.1 0.2 0.3 0.4 0.5 1 2 3 4 5 10 20 30 40 50 60 70 80 90 100)

for pct in "${values[@]}"; do
  name=$(echo "$pct" | tr '.' '_')
  mkdir -p "/sys/fs/cgroup/cpu$name"
  quota=$(awk "BEGIN {printf \"%.0f\", $pct * 20000}")
  echo "$quota 100000" >"/sys/fs/cgroup/cpu$name/cpu.max"
done
