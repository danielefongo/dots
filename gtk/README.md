# Guide to add a new gtk version

- clone <https://github.com/GNOME/gtk>
- checkout to a specific version (using tags)
- copy a theme folder inside gtk/theme/ (e.g. Adwaita) inside this folder as gtk-<VERSION>
- remove useless files (e.g. already generated .css files)
- update the `build` script
