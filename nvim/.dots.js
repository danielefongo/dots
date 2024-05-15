const path = require("path");
const { exec } = require("child_process");
const lockFilename = path.join(path.resolve(__dirname), "lazy-lock.json");

module.exports = {
  match: [{ pattern: "nvim/**/*.lua" }],
  apply: () => {
    exec(`ln -sf ${lockFilename} ./output/nvim/lazy-lock.json`);
  },
};
