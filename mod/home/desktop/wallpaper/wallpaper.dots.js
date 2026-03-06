const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "background.svg", to: "wallpaper" }],
  apply: () => {
    exec("systemctl --user restart wallpaper.service");
  },
};
