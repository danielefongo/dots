const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "dunstrc", to: "dunst" }],
  apply: (_) => {
    exec("systemctl --user restart dunst && notify-send Dunst restarted");
  },
};
