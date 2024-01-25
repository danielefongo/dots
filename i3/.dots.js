const { execSync } = require("child_process");

module.exports = {
  match: "i3/**/*",
  apply: (_) => {
    execSync("i3-msg restart || true");
  },
};
