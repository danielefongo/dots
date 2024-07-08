const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "**/*", to: "i3" }],
  apply: (_) => {
    exec("i3restart");
  },
};
