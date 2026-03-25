{ pkgs, ... }:

final: prev: {
  tmuxinator = prev.unstable.tmuxinator;
}
