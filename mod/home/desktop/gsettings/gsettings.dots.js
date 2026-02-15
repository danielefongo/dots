const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "theme", to: "gsettings/" }],
  apply: () => {
    exec("systemctl --user list-unit-files gsettings.service", (_, stdout) => {
      if (stdout.includes("gsettings.service")) {
        exec("systemctl --user restart gsettings.service");
      }
    });
  },
};
