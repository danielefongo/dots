{ lib, pkgs, ... }:

let
  fzfWrapper = pkgs.writeShellScriptBin "fzf" ''
    export FZF_DEFAULT_OPTS_FILE=~/.fzf.conf
    ${pkgs.fzf}/bin/fzf "$@"
  '';
in
lib.opts.module "shell.fzf" { } (cfg: {
  home.packages = [ fzfWrapper ];

  home.file.".fzf.conf".source = pkgs.dot.outLink "fzf/fzf.conf";
})
