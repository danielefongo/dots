const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "xbindkeysrc", to: "xbindkeys" }],
  apply: (_) => {
    exec("systemctl --user is-active xbindkeys.service", (_, stdout) => {
      if (stdout.trim() === "active") {
        exec("systemctl --user restart xbindkeys.service");
      }
    });
  },
};
