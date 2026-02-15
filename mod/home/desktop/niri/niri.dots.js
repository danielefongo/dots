const { exec } = require("child_process");

module.exports = {
  match: [
    { pattern: "config.kdl", to: "niri" },
    { pattern: "lock.sh", to: "niri" },
  ],
};
