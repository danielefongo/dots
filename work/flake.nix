{
  description = "Work dotfiles";
  inputs = {
    # root flake
    root-flake.url = "../.";
    # work inputs
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "root-flake/nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "root-flake/nixpkgs";
    };
    suite_py = {
      url = "git+ssh://git@github.com/primait/suite_py";
      inputs.nixpkgs.follows = "root-flake/nixpkgs-unstable";
    };
    prima-nix = {
      url = "git+ssh://git@github.com/primait/prima.nix.git";
      inputs.nixpkgs.follows = "root-flake/nixpkgs-unstable";
    };
  };
  outputs =
    { root-flake, ... }@work_inputs:
    let
      inputs = root-flake.inputs // work_inputs;
      system = "x86_64-linux";
      pkgs = root-flake.mkPkgs {
        inherit system;

        extraOverlays = [
          inputs.nixgl.overlay
          inputs.suite_py.overlays.default
          (import ./pkgs { inherit pkgs inputs system; })
        ];
      };

      user_data = root-flake.user_data;
    in
    {
      formatter.x85_64-linux = pkgs.nixfmt-rfc-style;

      homeConfigurations."${user_data.user}" = pkgs.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = inputs // {
          inherit user_data;
        };
        modules = [ ./home.nix ];
      };

      systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
        extraSpecialArgs = inputs // {
          inherit user_data system pkgs;
        };
        modules = [ ./system ];
      };
    };
}
