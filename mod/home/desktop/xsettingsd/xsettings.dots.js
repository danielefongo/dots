const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "xsettingsd.conf", to: "xsettingsd/" }],
  apply: () => {
    exec("systemctl --user is-active xsettingsd.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart xsettingsd.service");
      }
    });
  },
};
