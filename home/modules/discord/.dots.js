const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "**/*", to: "discord" }],
  apply: () => {
    exec(
      `mv ~/.config/vesktop/themes/discord.theme.css ~/.config/vesktop/themes/discord.theme.old.css; mv ~/.config/vesktop/themes/discord.theme.old.css ~/.config/vesktop/themes/discord.theme.css`,
    );
  },
};
