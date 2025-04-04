const { execSync } = require("child_process");
const { writeFileSync, renameSync, existsSync, unlinkSync } = require("fs");
const { join } = require("path");

module.exports = {
  match: [{ pattern: "**/*", to: "vial" }],
  apply: (p) => {
    const file = join(p, "modules/vial/voyager_keymap.vil");
    const tmp = file + ".tmp";

    try {
      const out = execSync(`jq . ${file}`);
      writeFileSync(tmp, out);
      renameSync(tmp, file);
    } catch {
      if (existsSync(tmp)) unlinkSync(tmp);
      console.error("jq failed, file not overwritten.");
    }
  },
};
