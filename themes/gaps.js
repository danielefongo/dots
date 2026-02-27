let baseTheme = require("./base.js");

module.exports = {
  ...baseTheme,
  name: "Gaps",
  data: {
    ...baseTheme.data,
    gap: 20,
    round: 10,
  },
};
