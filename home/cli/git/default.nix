{ lib, pkgs, ... }:

lib.homeOpts.module "cli.git" { } (_: {
  programs.git = {
    enable = true;
    includes = [
      { path = pkgs.dot.outLink "git/delta"; }
      { path = pkgs.dot.outLink "git/extra_config"; }
    ];
    settings = {
      user = {
        name = "danielefongo";
        email = "danielefongo@gmail.com";
      };
      core = {
        editor = "nvim";
        excludesfile = builtins.toString (pkgs.dot.outLink "git/ignore");
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  home.packages = with pkgs; [
    gh
    lazygit
  ];
})
