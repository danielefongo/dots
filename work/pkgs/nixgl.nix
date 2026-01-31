{ inputs, system, ... }:

let
  nixglPkgs = import inputs.nixgl {
    pkgs = import inputs.nixgl.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    nvidiaVersion = "580.95.05";
    nvidiaHash = "19w227zb4qfrwpj6g53nk8d4zm832cfg3sfdn839haw4ivpz17l4";
    enable32bits = false;
  };

in
(inputs.nixgl.packages.${system} // nixglPkgs)
