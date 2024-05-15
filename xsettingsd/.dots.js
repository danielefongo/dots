const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "xsettingsd/**/*" }],
  apply: () => {
    exec("systemctl --user daemon-reload");
    exec("systemctl --user restart xsettingsd.service");
  },
};
