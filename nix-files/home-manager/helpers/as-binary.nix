{ pkgs, ... }:

let
  scriptToBinary = scriptContent: pkgs.writeScriptBin "custom-script" scriptContent;
in
(scriptContent: "${scriptToBinary scriptContent}/bin/custom-script")
