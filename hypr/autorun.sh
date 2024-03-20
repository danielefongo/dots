dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP

# systemctl --user start hypr-session.target
systemctl --user start hyprland-session.target
