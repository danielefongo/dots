const { execSync } = require("child_process");

module.exports = {
  match: "dunst/**/*",
  apply: (_) => {
    execSync("systemctl --user restart dunst");
    execSync("notify-send Dunst restarted");
  },
};
