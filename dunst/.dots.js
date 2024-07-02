const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "dunst/dunstrc" }],
  apply: (_) => {
    exec("systemctl --user restart dunst && notify-send Dunst restarted");
  },
};
