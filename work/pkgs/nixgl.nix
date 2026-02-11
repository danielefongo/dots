{ inputs, system, ... }:

let
  nixglPkgs = import inputs.nixgl {
    pkgs = import inputs.nixgl.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    nvidiaVersion = "590.48.01";
    nvidiaHash = "12fnddljvgxksil6n3d5a35wwg8kkq82kkglhz63253qjc3giqmr";
    enable32bits = false;
  };

in
(inputs.nixgl.packages.${system} // nixglPkgs)
