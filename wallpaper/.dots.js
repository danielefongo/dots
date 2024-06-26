const { execSync, exec } = require("child_process");

module.exports = {
  match: [{ pattern: "wallpaper/*.js" }],
  apply: () => {
    execSync(
      "$(mise where nodejs)/bin/node wallpaper/index.js output/wallpaper/settings.js output/wallpaper/background.svg",
    );
    exec("systemctl --user restart wallpaper");
  },
};
