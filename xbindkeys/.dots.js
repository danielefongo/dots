const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "xbindkeys/.xbindkeysrc" }],
  apply: (_) => {
    exec("systemctl --user restart xbindkeys");
  },
};
