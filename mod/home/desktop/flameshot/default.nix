{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";

  ocr = pkgs.writeShellScriptBin "ocr" ''
    #!/usr/bin/env sh
    lang=''${1:-ita+eng}
    tmp=$(mktemp /tmp/ocr-XXXXXX.png)
    ${pkgs.flameshot}/bin/flameshot gui --raw > "$tmp"
    ocr_text=$(${pkgs.tesseract}/bin/tesseract -l "$lang" "$tmp" stdout)
    rm "$tmp"
    echo "$ocr_text" | ${
      if isWayland then
        "${pkgs.wl-clipboard}/bin/wl-copy"
      else
        "${pkgs.xclip}/bin/xclip -selection clipboard"
    }
    ${pkgs.libnotify}/bin/notify-send "OCR" "<b>Success!</b>"
  '';
in
lib.homeOpts.module "desktop.flameshot" { } (_: {
  home.packages =
    with pkgs;
    [
      flameshot
      ocr
    ]
    ++ lib.optionals isWayland [
      grim
      wl-clipboard
    ]
    ++ lib.optionals (!isWayland) [ xclip ];

  xdg.configFile."flameshot".source = pkgs.dot.outLink "flameshot";

  systemd.user.services.flameshot = {
    Unit = {
      Description = "Flameshot";
      PartOf = [ sessionTarget ];
      After = [ sessionTarget ];
    };
    Install = {
      WantedBy = [ sessionTarget ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.flameshot;
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
})
