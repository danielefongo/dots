const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "redshift.conf", to: "redshift" }],
  apply: () => {
    exec("systemctl --user is-active redshift.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart redshift.service");
      }
    });
  },
};
