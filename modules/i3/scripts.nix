{ pkgs, config, dots_path, ... }:

let
  i3resize = pkgs.writeShellScriptBin "i3resize" ''
    [ -z "$1" ] && echo "No direction provided" && exit 1
    distanceStr="4 px or 4 ppt"

    moveChoice() {
    	${pkgs.i3}/bin/i3-msg resize "$1" "$2" "$distanceStr" | grep '"success":true' ||
    		${pkgs.i3}/bin/i3-msg resize "$3" "$4" "$distanceStr"
    }

    case $1 in
    up) moveChoice grow up shrink down;;
    down) moveChoice shrink up grow down;;
    left) moveChoice shrink right grow left;;
    right) moveChoice grow right shrink left;;
    esac
  '';

  i3restart = pkgs.writeShellScriptBin "i3restart" ''
    current_coordinates=$(${pkgs.xdotool}/bin/xdotool getmouselocation --shell)

    i3-msg restart || true

    eval "$(echo "$current_coordinates" | grep X)"
    eval "$(echo "$current_coordinates" | grep Y)"

    ${pkgs.xdotool}/bin/xdotool mousemove $X $Y
  '';
in
{
  home.packages = [
    i3resize
    i3restart
  ];
}
