{ inputs, system, ... }:

(inputs.plover.packages.${system}.plover.withPlugins (
  ps: with ps; [
    plover-lapwing-aio
  ]
))
