const { execSync, exec } = require("child_process");

module.exports = {
  match: [
    {
      pattern: "**/*",
      to: "gtk",
      filter: (file) => {
        return file.includes(".css") || file.includes(".scss");
      },
    },
  ],
  apply: (path) => {
    execSync(`${path}/output/gtk/build`);
    exec("systemctl --user list-unit-files xsettingsd.service", (_, stdout) => {
      if (stdout.includes("xsettingsd.service")) {
        exec("systemctl --user restart xsettingsd.service");
      }
    });
    exec("systemctl --user list-unit-files gsettings.service", (_, stdout) => {
      if (stdout.includes("gsettings.service")) {
        exec("systemctl --user restart gsettings.service");
      }
    });
  },
};
