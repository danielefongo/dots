let baseTheme = require("./base.js");

module.exports = {
  ...baseTheme,
  name: "Galaxy",
  data: {
    ...baseTheme.data,
    contrast: 8,
  },
};
