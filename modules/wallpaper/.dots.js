const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "*.js", to: "wallpaper" }],
  apply: () => {
    exec("systemctl --user restart wallpaper.service");
  },
};
