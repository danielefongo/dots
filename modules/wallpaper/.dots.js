const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "*.js", to: "wallpaper" }],
  apply: () => {
    exec("systemctl --user is-active wallpaper.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart wallpaper.service");
      }
    });
  },
};
