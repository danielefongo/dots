const { exec, execSync } = require("child_process");

module.exports = {
  match: [{ pattern: "config/**/*", to: "waybar", from: "config" }],
  apply: (path) => {
    execSync(
      `sassc -a -M -t compact ${path}/output/waybar/style.scss ${path}/output/waybar/style.css`,
    );
    exec("systemctl --user is-active waybar.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart waybar.service");
      }
    });
  },
};
