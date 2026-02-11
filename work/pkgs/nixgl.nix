{ inputs, system, ... }:

let
  nixglPkgs = import inputs.nixgl {
    pkgs = import inputs.nixgl.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    nvidiaVersion = "580.126.09";
    nvidiaHash = "TKxT5I+K3/Zh1HyHiO0kBZokjJ/YCYzq/QiKSYmG7CY=";
    enable32bits = false;
  };

in
(inputs.nixgl.packages.${system} // nixglPkgs)
