{ inputs, system, ... }:

let
  nixglPkgs = import inputs.nixgl {
    pkgs = import inputs.nixgl.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    nvidiaVersion = "595.58.03";
    nvidiaHash = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
    enable32bits = false;
  };

in
(inputs.nixgl.packages.${system} // nixglPkgs)
