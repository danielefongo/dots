{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs.url = "github:nix-community/NUR";
    nixgl.url = "github:nix-community/nixGL";
    plover.url = "github:openstenoproject/plover-flake";
    suite_py.url = "git+ssh://git@github.com/primait/suite_py";
    prima-nix.url = "git+ssh://git@github.com/primait/prima.nix.git";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      system-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "danielefongo";
      home = "/home/danielefongo";
      dots_path = "/home/danielefongo/dots";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          inputs.nixgl.overlay
          inputs.suite_py.overlays.default
          inputs.nurpkgs.overlays.default
          (self: super: { lib = super.lib // home-manager.lib // { hm = home-manager.lib.hm; }; })
          (self: super: {
            config = super.config // {
              allowUnfree = true;
              allowAliases = true;
            };
          })
          (self: super: {
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
          (import ./pkgs { inherit lib pkgs inputs; })
        ];
      };
      lib = (
        import ./lib {
          inherit
            system
            inputs
            pkgs
            dots_path
            ;
        }
      );
    in
    {
      formatter.x85_64-linux = pkgs.nixfmt-rfc-style;

      homeConfigurations."${user}" = pkgs.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit lib;

        extraSpecialArgs = inputs // {
          inherit user;
          inherit home;
          inherit dots_path;
        };
        modules = [ ./home.nix ];
      };

      systemConfigs.default = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = inputs // {
          inherit system;
          inherit pkgs;
        };
        modules = [ ./system.nix ];
      };
    };
}
