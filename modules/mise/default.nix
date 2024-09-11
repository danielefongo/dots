{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zlib
    ncurses
  ];

  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        erlang = "latest";
        elixir = "latest";
        elm = "latest";
        lua = "latest";
        nodejs = "latest";
        python = "latest";
        rust = "latest";
      };
    };
  };
}
