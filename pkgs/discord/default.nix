{ pkgs, ... }:

final: prev:
let
  discordPatcher = prev.writers.writePython3Bin "discord-krisp-patcher" {
    libraries = with prev.python3Packages; [
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
{
  discord = prev.discord.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];

    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/opt/${binaryName}/${binaryName} \
        --run '${discordPatcher}/bin/discord-krisp-patcher ~/.config/discord/*/modules/discord_krisp/discord_krisp.node 2>/dev/null || true'
    '';

    passthru = builtins.removeAttrs (old.passthru or { }) [ "updateScript" ];

    meta = (old.meta or { }) // {
      nyx.bypassLicense = true;
    };
  });
}
