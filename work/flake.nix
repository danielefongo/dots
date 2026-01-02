{
  description = "Work dotfiles";

  inputs = {
    # root flake inputs
    root-flake.url = "../.";
    nixpkgs.follows = "root-flake/nixpkgs";
    nixpkgs-unstable.follows = "root-flake/nixpkgs-unstable";
    home-manager.follows = "root-flake/home-manager";
    nurpkgs.follows = "root-flake/nurpkgs";
    plover.follows = "root-flake/plover";

    # work inputs
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "root-flake/nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    suite_py.url = "git+ssh://git@github.com/primait/suite_py";
    prima-nix.url = "git+ssh://git@github.com/primait/prima.nix.git";
  };
  outputs =
    {
      nixpkgs,
      system-manager,
      root-flake,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = root-flake.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = root-flake.overlays.default ++ [
          inputs.nixgl.overlay
          inputs.suite_py.overlays.default
          (import ./pkgs { inherit lib pkgs inputs; })
        ];
      };

      user_data = root-flake.user_data;
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      homeConfigurations."${user_data.user}" = pkgs.lib.homeManagerConfiguration {
        inherit pkgs lib;

        extraSpecialArgs = inputs // {
          inherit user_data;
        };
        modules = [ ./home.nix ];
      };

      systemConfigs.default = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = inputs // {
          inherit system pkgs;
        };
        modules = [ ./system.nix ];
      };
    };
}
