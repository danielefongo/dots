const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "polybar/**/*" }],
  apply: (_) => {
    exec("systemctl --user restart polybar");
  },
};
