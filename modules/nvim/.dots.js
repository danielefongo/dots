const path = require("path");
const { exec } = require("child_process");
const lockFilename = path.join(path.resolve(__dirname), "lazy-lock.json");

module.exports = {
  match: [{ pattern: "**/*.lua", to: "nvim" }],
  apply: (path) => {
    exec(`ln -sf ${lockFilename} ${path}/output/nvim/lazy-lock.json`);
  },
};
