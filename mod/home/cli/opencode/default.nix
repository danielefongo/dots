{
  pkgs,
  lib,
  user,
  ...
}:

lib.homeOpts.module "cli.opencode" { } (_: {
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/config.json".source = pkgs.dot.outLink "opencode/config.json";
  xdg.configFile."opencode/skills".source = pkgs.dot.outOfStore "${user.home}/.agents/skills";
})
