const path = require("path");
const { execSync } = require("child_process");
const lockFilename = path.join(path.resolve(__dirname), "lazy-lock.json");

module.exports = {
  match: "nvim/**/*.lua",
  apply: () => {
    execSync(`ln -sf ${lockFilename} ./output/nvim/lazy-lock.json`);
  },
};
