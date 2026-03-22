{ pkgs, ... }:
let
  sopsCompletions = pkgs.path + "/pkgs/by-name/so/sops";
in
final: prev: {
  sops = prev.buildGoModule {
    pname = "sops";
    version = "3.12.2";

    src = prev.fetchFromGitHub {
      owner = "getsops";
      repo = "sops";
      tag = "v3.12.2";
      hash = "sha256-1VGaS0uhacxjNOP/USmFHlrewkGzRzrV6xamDXY8hgc=";
    };

    vendorHash = "sha256-HgfJMTTWzQ4+59nuy/et3KxQaZEcfrjcWSr/iOOdpb0=";

    subPackages = [ "cmd/sops" ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/getsops/sops/v3/version.Version=3.12.2"
    ];

    nativeBuildInputs = with prev; [
      installShellFiles
      makeWrapper
    ];

    postInstall = ''
      installShellCompletion --cmd sops --bash ${sopsCompletions}/bash_autocomplete
      installShellCompletion --cmd sops --zsh ${sopsCompletions}/zsh_autocomplete
    '';

    meta = {
      homepage = "https://getsops.io/";
      description = "Simple and flexible tool for managing secrets";
      mainProgram = "sops";
      license = prev.lib.licenses.mpl20;
    };
  };
}
