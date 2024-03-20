const { execSync } = require("child_process");

module.exports = {
  match: "redshift/redshift.conf",
  apply: () => {
    execSync("systemctl --user restart redshift.service");
  },
};
