{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    includes = [
      { path = pkgs.outLink "git/delta"; }
      { path = pkgs.outLink "git/extra_config"; }
    ];
    settings = {
      user = {
        name = "danielefongo";
        email = "danielefongo@gmail.com";
      };
      core = {
        editor = "nvim";
        excludesfile = builtins.toString (pkgs.outLink "git/ignore");
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
}
