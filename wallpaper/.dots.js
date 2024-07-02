const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "wallpaper/*.js" }],
  apply: () => {
    exec("systemctl --user restart wallpaper");
  },
};
