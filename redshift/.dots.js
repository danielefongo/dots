const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "redshift/redshift.conf" }],
  apply: () => {
    exec("systemctl --user restart redshift.service");
  },
};
