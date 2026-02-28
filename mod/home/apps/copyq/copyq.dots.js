const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "**/copyq*", to: "copyq" }],
  apply: (_) => {
    exec("systemctl --user is-active copyq.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart copyq.service");
      }
    });
  },
};
