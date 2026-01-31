{
  pkgs,
  inputs,
  system,
  ...
}:

(final: prev: {
  homeManagerConfiguration = inputs.home-manager.lib.homeManagerConfiguration;

  nixgl = pkgs.callPackage ./nixgl.nix { inherit inputs system; };
  electronWithGPU = pkgs.callPackage ./electronWithGPU.nix { inherit inputs system; };
})
