{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    suite_py.url = "git+ssh://git@github.com/primait/suite_py";
  };

  outputs = { nixpkgs, home-manager, system-manager, ... } @inputs:
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
          (self: super: {
            lib = super.lib // home-manager.lib // {
              hm = home-manager.lib.hm;
            };
          })
          (self: super: {
            config = super.config // {
              allowUnfree = true;
              allowAliases = true;
            };
          })
          (import ./pkgs { inherit pkgs; })
        ];
      };

      lib = (import ./lib {
        inherit system inputs pkgs dots_path;
      });
    in
    {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      homeConfigurations."${user}" = pkgs.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit lib;

        extraSpecialArgs = {
          inherit user;
          inherit home;
          inherit dots_path;
        };

        modules = [
          ./home.nix
        ];
      };

      systemConfigs.default = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = inputs // {
          inherit system;
          inherit pkgs;
        };

        modules = [
          ./system.nix
        ];
      };
    };
}
