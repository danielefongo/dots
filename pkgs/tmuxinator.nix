{
  lib,
  buildRubyGem,
  ruby,
  installShellFiles,
  ...
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "tmuxinator";
  version = "3.3.7";
  source.sha256 = "sha256-z0E/zS6o8MXW4Gi6KqtusRtPpUBa5XhGMAsNJGZxL7I=";

  erubi = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "erubi";
    version = "1.13.0";
    source.sha256 = "fca61b47daefd865d0fb50d168634f27ad40181867445badf6427c459c33cd62";
  };

  thor = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "thor";
    version = "1.4.0";
    source.sha256 = "sha256-h2PoIsyw8de+6IzeExsZplYGZXuEfMe3tLgudyvNij0=";
  };

  xdg = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "xdg";
    version = "2.2.5";
    source.sha256 = "04xr4cavnzxlk926pkji7b5yiqy4qsd3gdvv8mg6jliq6sczg9gk";
  };

  propagatedBuildInputs = [
    erubi
    thor
    xdg
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion $GEM_HOME/gems/${gemName}-${version}/completion/tmuxinator.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "Manage complex tmux sessions easily";
    homepage = "https://github.com/tmuxinator/tmuxinator";
    license = licenses.mit;
    maintainers = with maintainers; [
      auntie
    ];
    platforms = platforms.unix;
    mainProgram = "tmuxinator";
  };
}
