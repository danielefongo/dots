{
  inputs,
  lib,
  pkgs,
  user_data,
  ...
}:

(self: super: {
  ocr = pkgs.callPackage ./ocr.nix { pkgs = super; };
  tmuxinator = pkgs.callPackage ./tmuxinator.nix { pkgs = super; };
  firefox-addons = pkgs.callPackage ./firefox-addons.nix { pkgs = super; };
  plover = pkgs.callPackage ./plover.nix {
    inherit inputs;
    pkgs = super;
  };
  nix-scripts = pkgs.callPackage ./nix-scripts {
    inherit lib user_data;
    pkgs = super;
  };
})
