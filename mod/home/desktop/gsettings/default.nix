{ lib, pkgs, ... }:

let
  themeFile = pkgs.dot.outLink "gsettings/theme";

  applyTheme = pkgs.writeShellScriptBin "apply-gsettings-theme" ''
    export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS"

    THEME_NAME=$(cat "${themeFile}" 2>/dev/null || echo "gtk-theme")
    ${pkgs.glib}/bin/gsettings reset org.gnome.desktop.interface gtk-theme
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
  '';
in
lib.homeOpts.module "desktop.gsettings" { } (_: {
  xdg.configFile."gsettings-theme".source = pkgs.dot.outLink "gsettings";

  mod.home.desktop.gtk.enable = true;

  systemd.user.services.gsettings = {
    Unit = {
      Description = "Gsettings daemon";
      PartOf = [ "wayland-session.target" ];
    };

    Install = {
      WantedBy = [ "wayland-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${applyTheme}/bin/apply-gsettings-theme";
      RemainAfterExit = false;
    };
  };
})
