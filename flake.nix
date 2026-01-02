{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs.url = "github:nix-community/NUR";
    plover.url = "github:openstenoproject/plover-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      user_data = {
        user = "danielefongo";
        home = "/home/danielefongo";
        dots_path = "/home/danielefongo/dots";
      };

      overlays = [
        inputs.nurpkgs.overlays.default
        (self: super: {
          lib = super.lib // home-manager.lib // { hm = home-manager.lib.hm; };
        })
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
        (import ./pkgs {
          inherit
            lib
            pkgs
            inputs
            user_data
            ;
        })
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      };

      lib = import ./lib {
        inherit
          system
          inputs
          pkgs
          user_data
          ;
      };

      homeManager = {
        home-manager.extraSpecialArgs = inputs // {
          inherit system pkgs user_data;
        };
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        inherit system pkgs lib;

        specialArgs = {
          inherit inputs user_data;
        };

        modules = [
          ./hosts/tower
          homeManager
        ];
      };

      # for work flake (ORA valido)
      pkgs = pkgs;
      lib = lib;
      overlays = {
        default = overlays;
      };
      user_data = user_data;

      packages.${system} = {
        nix-theme =
          (pkgs.callPackage ./pkgs/nix-scripts {
            user_data =
              let
                env = builtins.getEnv;
                require =
                  name:
                  let
                    v = env name;
                  in
                  if v == "" then throw "${name} is not set" else v;
              in
              {
                user = require "DOTS_USER";
                home = require "DOTS_HOME";
                dots_path = require "DOTS_PATH";
              };
          }).nix-theme;

        default = self.packages.${system}.nix-theme;
      };

    };
}
