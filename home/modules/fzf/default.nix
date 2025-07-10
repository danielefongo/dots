{ lib, pkgs, ... }:

let
  fzfWrapper = pkgs.writeShellScriptBin "fzf" ''
    export FZF_DEFAULT_OPTS_FILE=~/.fzf.conf
    ${pkgs.fzf}/bin/fzf "$@"
  '';
in
{
  home.packages = [ fzfWrapper ];

  home.file.".fzf.conf".source = lib.outLink "fzf/fzf.conf";
}
