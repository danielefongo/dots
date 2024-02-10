const { execSync } = require("child_process");

module.exports = {
  match: "wallpaper/*.js",
  apply: () => {
    execSync("node wallpaper/index.js");
    execSync("systemctl --user restart wallpaper");
  },
};
