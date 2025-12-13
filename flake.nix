{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs.url = "github:nix-community/NUR";
    plover.url = "github:openstenoproject/plover-flake";
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

      overlays = [
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

      lib = (
        import ./lib {
          inherit
            system
            inputs
            pkgs
            user_data
            ;
        }
      );

      homeManager = {
        home-manager.extraSpecialArgs = inputs // {
          inherit system pkgs user_data;
        };
      };
    in
    {
      formatter.x85_64-linux = pkgs.nixfmt-rfc-style;

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

      # for work flake
      pkgs = pkgs;
      lib = lib;
      overlays = overlays;
      user_data = user_data;
    };
}
