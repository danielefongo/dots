{ pkgs, ... }:

let
  scriptToBinary = scriptContent: pkgs.writeScriptBin "custom-script" scriptContent;
in
{
  scriptToBinary = (scriptContent: "${scriptToBinary scriptContent}/bin/custom-script");
}
