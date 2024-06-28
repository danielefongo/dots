const { execSync, exec } = require("child_process");

module.exports = {
  match: [{ pattern: "wallpaper/*.js" }],
  apply: (path) => {
    execSync(
      `$(mise where nodejs)/bin/node ${path}/wallpaper/index.js ${path}/output/wallpaper/settings.js ${path}/output/wallpaper/background.svg`,
    );
    exec("systemctl --user restart wallpaper");
  },
};
