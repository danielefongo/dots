const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "*", to: "gammastep" }],
  apply: () => {
    exec("systemctl --user list-unit-files gammastep.service", (_, stdout) => {
      if (stdout.includes("gammastep.service")) {
        exec("systemctl --user restart gammastep.service");
      }
    });
  },
};
