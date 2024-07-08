const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: ".xbindkeysrc", to: "xbindkeys" }],
  apply: (_) => {
    exec("systemctl --user restart xbindkeys");
  },
};
