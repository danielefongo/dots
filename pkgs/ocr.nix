{ pkgs, ... }:

pkgs.writeShellScriptBin "ocr" ''
  #!/usr/bin/env sh
  lang=''${1:-ita+eng}
  ocr_text=$(${pkgs.flameshot}/bin/flameshot gui --raw | ${pkgs.tesseract}/bin/tesseract -l $lang stdin stdout)
  echo "$ocr_text" | ${pkgs.xclip}/bin/xclip -selection clipboard
  notify-send "OCR" "<b>Success!</b>"
''
