const { execSync, exec } = require("child_process");

module.exports = {
  match: [{ pattern: "wallpaper/*.js" }],
  apply: (path) => {
    execSync(
      `wallpaper ${path}/output/wallpaper/settings.js ${path}/output/wallpaper/background.svg`,
    );
    exec("systemctl --user restart wallpaper");
  },
};
