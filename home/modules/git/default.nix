{ lib, ... }:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    includes = [
      { path = lib.outLink "git/delta"; }
      { path = lib.outLink "git/extra_config"; }
    ];

    extraConfig = {
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
}
