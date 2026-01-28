{ pkgs, lib, ... }:

lib.opts.module "cli" { } (cfg: {
  imports = (lib.modulesIn ./.) ++ [
    (lib.package "cli.choose" pkgs.choose)
    (lib.package "cli.cloc" pkgs.cloc)
    (lib.package "cli.csvlens" pkgs.csvlens)
    (lib.package "cli.curl" pkgs.curl)
    (lib.package "cli.dust" pkgs.dust)
    (lib.package "cli.fastmod" pkgs.fastmod)
    (lib.package "cli.fd" pkgs.fd)
    (lib.package "cli.jq" pkgs.jq)
    (lib.package "cli.kondo" pkgs.kondo)
    (lib.package "cli.less" pkgs.less)
    (lib.package "cli.ncdu" pkgs.ncdu)
    (lib.package "cli.ripgrep" pkgs.ripgrep)
    (lib.package "cli.tldr" pkgs.tldr)
    (lib.package "cli.tree" pkgs.tree)
    (lib.package "cli.xclip" pkgs.xclip)
    (lib.package "cli.zoxide" pkgs.zoxide)
    (lib.package "cli.rip" pkgs.rip2)
    (lib.package "cli.tailscale" pkgs.tailscale)
    (lib.package "cli.yubikey" pkgs.yubikey-manager)
    (lib.opts.module "cli.direnv" { } (cfg: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }))
    (lib.package "cli.docker" pkgs.docker)
  ];
})
