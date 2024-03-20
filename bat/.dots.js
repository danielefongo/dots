const { execSync } = require("child_process");

module.exports = {
  match: "bat/**/*",
  apply: () => {
    execSync("bat cache --build");
  },
};
