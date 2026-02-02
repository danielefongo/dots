{ pkgs, ... }:
let
  discordPatcher = pkgs.writers.writePython3Bin "discord-krisp-patcher" {
    libraries = with pkgs.python3Packages; [
      pyelftools
      capstone
    ];
    flakeIgnore = [
      "E265"
      "E501"
      "F403"
      "F405"
      "W391"
    ];
  } (builtins.readFile ./krisp-patch.py);

  binaryName = "Discord";
in
pkgs.discord.overrideAttrs (prev: {
  nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

  postInstall = (prev.postInstall or "") + ''
    wrapProgram $out/opt/${binaryName}/${binaryName} \
      --run '${discordPatcher}/bin/discord-krisp-patcher ~/.config/discord/*/modules/discord_krisp/discord_krisp.node 2>/dev/null || true'
  '';

  passthru = builtins.removeAttrs (prev.passthru or { }) [ "updateScript" ];

  meta = (prev.meta or { }) // {
    nyx.bypassLicense = true;
  };
})
