const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "**/*", to: "polybar" }],
  apply: (_) => {
    exec("systemctl --user restart polybar");
  },
};
