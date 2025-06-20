{ pkgs, ... }:

let
  nixGL = import ./nixgl.nix { pkgs = pkgs; };
in
(self: super: {
  codescene-cli = pkgs.callPackage ./codescene.nix { pkgs = super; };

  # NixGL wrapped pkgs
  telegram-desktop = nixGL.wrapNixGL super.telegram-desktop;
  whatsapp-for-linux = nixGL.wrapNixGL super.whatsapp-for-linux;
  picom = nixGL.wrapNixGL super.picom;
  alacritty = nixGL.wrapNixGL super.alacritty;
  vesktop = nixGL.wrapNixGL super.vesktop;
})
