const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "background.svg", to: "wallpaper" }],
  apply: () => {
    exec("systemctl --user start wallpaper.service");
  },
};
