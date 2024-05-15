const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "redshift/redshift.conf" }],
  apply: () => {
    exec("systemctl --user daemon-reload");
    exec("systemctl --user restart redshift.service");
  },
};
