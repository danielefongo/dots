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
    exec("systemctl --user is-active xsettingsd.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart xsettingsd.service");
      }
    });
  },
};
