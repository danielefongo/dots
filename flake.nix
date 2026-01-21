{
  description = "Dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-optional-modules = {
      url = "github:danielefongo/nix-optional-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plover = {
      url = "github:openstenoproject/plover-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      user_data = {
        user = "danielefongo";
        home = "/home/danielefongo";
        dots_path = "/home/danielefongo/dots";
      };

      mkOverlays = inputs: pkgs: [
        inputs.nurpkgs.overlays.default
        (final: prev: { lib = prev.lib // home-manager.lib // { hm = home-manager.lib.hm; }; })
        (final: prev: {
          lib = prev.lib // {
            opts = inputs.nix-optional-modules.lib;
          };
        })
        (final: prev: {
          lib =
            prev.lib
            // (import ./lib {
              lib = prev.lib;
              inherit system inputs user_data;
            });
        })
        (final: prev: {
          config = prev.config // {
            allowUnfree = true;
            allowAliases = true;
          };
        })
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
        (import ./pkgs {
          inherit pkgs inputs user_data;
        })
      ];

      mkPkgs =
        {
          system,
          extraOverlays ? [ ],
        }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = (mkOverlays inputs pkgs) ++ extraOverlays;
          };
        in
        pkgs;

      pkgs = mkPkgs { inherit system; };

      homeManager = {
        home-manager.extraSpecialArgs = inputs // {
          inherit pkgs user_data;
        };
      };
    in
    {
      formatter.x85_64-linux = pkgs.nixfmt-rfc-style;

      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        inherit pkgs;

        specialArgs = {
          lib = pkgs.lib;
          inherit inputs user_data;
        };

        modules = [
          ./hosts/tower
          homeManager
        ];
      };

      inherit inputs user_data mkPkgs;
    };
}
