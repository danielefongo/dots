{ inputs, ... }:

(final: prev: {
  homeManagerConfiguration = inputs.home-manager.lib.homeManagerConfiguration;
})
