const { exec } = require("child_process");

module.exports = {
  match: [{ pattern: "**/*", to: "kitty" }],
  apply: () => {
    exec(
      "ps -eo pid,comm | grep kitty | grep -v kitten | awk '{print $1}'",
      (err, stdout) => {
        console.log(stdout);
        if (err || !stdout.trim()) return;
        stdout
          .trim()
          .split(/\s+/)
          .forEach((pid) => {
            try {
              process.kill(Number(pid), "SIGUSR1");
            } catch (_) {}
          });
      },
    );
  },
};
