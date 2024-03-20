const { execSync } = require("child_process");

module.exports = {
  match: "xsettingsd/**/*",
  apply: () => {
    execSync("systemctl --user restart xsettingsd.service");
  },
};
