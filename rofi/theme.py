#!/usr/bin/env python
import glob
import os
import rofi_menu
from pathlib import Path

dots_path = str(Path.home()) + "/dotfiles/dots/"


class Themes(rofi_menu.Menu):
    prompt = "menu"

    def __init__(self, themes=[]):
        self.items = map(self._gen, themes)

    def _gen(self, theme):
        return rofi_menu.ShellItem(theme, dots_path + "set_theme.sh " + theme)


if __name__ == "__main__":
    os.chdir(dots_path + "./theme/scheme/")
    files = glob.glob("*.json")

    themes = list(map(lambda x: x.replace(".json", ""), files))
    themes.sort()

    rofi_menu.run(Themes(themes))
