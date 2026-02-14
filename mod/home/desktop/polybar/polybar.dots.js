const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "config", to: "polybar" }],
  apply: (_) => {
    exec("systemctl --user is-active polybar.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart polybar.service");
      }
    });
  },
};
