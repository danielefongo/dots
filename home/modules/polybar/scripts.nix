{ lib, pkgs, ... }:

let
  cpu_temp = pkgs.writeShellScriptBin "cpu-temp" ''
    #!/usr/bin/env bash

    sensors="${pkgs.lm_sensors}/bin/sensors"

    cpu_temp=$($sensors | awk '/^Tctl:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
    if [ -z "$cpu_temp" ]; then
      cpu_temp=$($sensors | awk '/^Package id 0:/ {gsub(/\+|°C/, "", $4); print int($4); exit}')
    fi
    if [ -z "$cpu_temp" ]; then
      cpu_temp=$($sensors | awk '/temp1:/ {gsub(/\+|°C/, "", $2); print int($2); exit}')
    fi

    if [ -z "$cpu_temp" ]; then
      exit 0
    fi

    operator="$1"
    threshold="$2"

    if [ "$cpu_temp" "$operator" "$threshold" ]; then
      echo "$cpu_temp"
    else
      exit 0
    fi
  '';
in
{
  home.packages = with pkgs; [
    cpu_temp
  ];
}
