const { execSync } = require("child_process");

module.exports = {
  match: "polybar/**/*",
  apply: (_) => {
    execSync("systemctl --user restart polybar");
  },
};
