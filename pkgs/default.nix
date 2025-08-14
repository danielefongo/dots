{
  inputs,
  pkgs,
  user_data,
  ...
}:

(self: super: {
  ocr = pkgs.callPackage ./ocr.nix { pkgs = super; };
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  plover = pkgs.callPackage ./plover.nix {
    inherit inputs;
    pkgs = super;
  };
  nix-theme = pkgs.callPackage ./nix-theme {
    inherit user_data;
    pkgs = super;
  };
})
