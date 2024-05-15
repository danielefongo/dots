const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "i3/**/*" }],
  apply: (_) => {
    exec("i3restart");
  },
};
