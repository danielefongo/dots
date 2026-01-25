const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "dunstrc", to: "dunst" }],
  apply: (_) => {
    exec("systemctl --user is-active dunst.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec(
          "systemctl --user restart dunst.service && notify-send Dunst restarted",
        );
      }
    });
  },
};
