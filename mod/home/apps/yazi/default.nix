{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";

  yazi-open = pkgs.writeShellScriptBin "yazi-open" ''
    ${pkgs.kitty}/bin/kitty -e yazi "''${1:-~}"
  '';

  yazi-filemanager = pkgs.writeShellScriptBin "yazi-filemanager" ''
    exec ${
      pkgs.python3.withPackages (ps: [
        ps.dbus-python
        ps.pygobject3
      ])
    }/bin/python3 ${pkgs.writeText "filemanager1.py" ''
      import dbus
      import dbus.service
      import dbus.mainloop.glib
      from gi.repository import GLib
      import subprocess
      import os

      dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

      class FileManager1(dbus.service.Object):
          def __init__(self):
              bus = dbus.SessionBus()
              bus_name = dbus.service.BusName("org.freedesktop.FileManager1", bus)
              super().__init__(bus_name, "/org/freedesktop/FileManager1")

          @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
          def ShowFolders(self, uris, startup_id):
              for uri in uris:
                  path = uri.replace("file://", "")
                  subprocess.Popen(["${pkgs.kitty}/bin/kitty", "--instance-group", "yazi-open", "-e", "${pkgs.yazi}/bin/yazi", path])

          @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
          def ShowItems(self, uris, startup_id):
              for uri in uris:
                  path = os.path.dirname(uri.replace("file://", ""))
                  subprocess.Popen(["${pkgs.kitty}/bin/kitty", "--instance-group", "yazi-open", "-e", "${pkgs.yazi}/bin/yazi", path])

          @dbus.service.method("org.freedesktop.FileManager1", in_signature="ass", out_signature="")
          def ShowItemProperties(self, uris, startup_id):
              pass

      fm = FileManager1()
      GLib.MainLoop().run()
    ''}
  '';
in
lib.homeOpts.module "apps.yazi" { } (_: {
  xdg.desktopEntries.yazi = {
    name = "Yazi";
    comment = "Yazi";
    exec = "${yazi-open}/bin/yazi-open %u";
    icon = "folder";
    type = "Application";
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
    };
  };

  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.FileManager1
    Exec=${yazi-filemanager}/bin/yazi-filemanager
  '';

  systemd.user.services.yazi-filemanager = {
    Unit = {
      Description = "FileManager dbus service for yazi";
      After = [ sessionTarget ];
    };
    Install = {
      WantedBy = [ sessionTarget ];
    };
    Service = {
      ExecStart = "${yazi-filemanager}/bin/yazi-filemanager";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  mod.home.cli.yazi.enable = true;
})
