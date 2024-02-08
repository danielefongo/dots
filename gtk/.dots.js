const { execSync } = require("child_process");

module.exports = {
  match: "gtk/**/*",
  filter: (file) => {
    return file.includes(".css") || file.includes(".scss");
  },
  apply: (_) => {
    execSync("output/gtk/build");
    execSync("systemctl --user restart xsettingsd.service");
  },
};
