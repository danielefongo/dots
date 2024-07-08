const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "redshift.conf", to: "redshift" }],
  apply: () => {
    exec("systemctl --user restart redshift.service");
  },
};
