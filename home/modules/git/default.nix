{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    includes = [
      { path = lib.outLink "git/delta"; }
      { path = lib.outLink "git/extra_config"; }
    ];
    settings = {
      user = {
        name = "danielefongo";
        email = "danielefongo@gmail.com";
      };
      core = {
        editor = "nvim";
        excludesfile = builtins.toString (lib.outLink "git/ignore");
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  home.packages = with pkgs; [
    gh
  ];
}
