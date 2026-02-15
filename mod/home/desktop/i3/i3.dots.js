const { exec } = require("child_process");

module.exports = {
  match: [
    { pattern: "config", to: "i3" },
    { pattern: "lock.sh", to: "i3" },
  ],
  apply: (_, files) => {
    if (files.some((f) => f.endsWith("config"))) {
      exec("i3-restart");
    }
  },
};
