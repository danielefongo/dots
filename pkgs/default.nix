{ pkgs, ... }:

(self: super: {
  tmux = pkgs.callPackage ./tmux.nix { pkgs = super; };
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  codescene-cli = pkgs.callPackage ./codescene.nix { pkgs = super; };
})
