{ inputs, pkgs, ... }:

final: prev: {
  plover = inputs.plover.packages.${prev.system}.plover.withPlugins (
    ps: with ps; [
      plover-lapwing-aio
    ]
  );
}
