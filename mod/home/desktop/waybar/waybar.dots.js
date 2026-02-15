const { exec } = require("child_process");

module.exports = {
  match: [
    { pattern: "config", to: "waybar" },
    { pattern: "style.css", to: "waybar" },
  ],
  apply: () => {
    exec("systemctl --user list-unit-files waybar.service", (_, stdout) => {
      if (stdout.includes("waybar.service")) {
        exec("systemctl --user restart waybar.service");
      }
    });
  },
};
