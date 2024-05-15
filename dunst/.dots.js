const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "dunst/**/*" }],
  apply: (_) => {
    exec("systemctl --user daemon-reload");
    exec("systemctl --user restart dunst && notify-send Dunst restarted");
  },
};
