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
  nix-scripts = pkgs.callPackage ./nix-scripts {
    inherit user_data;
    pkgs = super;
  };
})
