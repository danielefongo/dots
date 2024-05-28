const { execSync, exec } = require("child_process");

module.exports = {
  match: [
    {
      pattern: "gtk/**/*",
      filter: (file) => {
        return file.includes(".css") || file.includes(".scss");
      },
    },
  ],
  apply: (_) => {
    execSync("output/gtk/build");
    exec("systemctl --user restart xsettingsd.service");
  },
};
