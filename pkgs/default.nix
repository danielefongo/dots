{
  inputs,
  lib,
  pkgs,
  user_data,
  ...
}:

let

  files = import ./files.nix {
    inherit pkgs user_data;
  };
  scripts = import ./scripts.nix {
    inherit pkgs user_data;
  };
in
(self: super: {
  ocr = pkgs.callPackage ./ocr.nix { pkgs = super; };
  tmuxinator = pkgs.callPackage ./tmuxinator.nix { pkgs = super; };
  firefox-addons = pkgs.callPackage ./firefox-addons.nix { pkgs = super; };
  plover = pkgs.callPackage ./plover.nix {
    inherit inputs;
    pkgs = super;
  };
  inherit (files) dotLink outLink outFile;
  inherit (scripts) dotScript;

  nix-scripts = pkgs.callPackage ./nix-scripts {
    inherit lib user_data scripts;
    pkgs = super;
  };
})
