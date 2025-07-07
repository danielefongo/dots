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
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      user = "danielefongo";
      home = "/home/danielefongo";
      dots_path = "/home/danielefongo/dots";

      user_data = {
        user = user;
        home = home;
        dots_path = dots_path;
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
        (import ./pkgs { inherit lib pkgs inputs; })
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
            dots_path
            ;
        }
      );
    in
    {
      formatter.x85_64-linux = pkgs.nixfmt-rfc-style;
      pkgs = pkgs;
      lib = lib;
      overlays = overlays;
      user_data = user_data;

      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit lib;
        inherit pkgs;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          {
            imports = [
              home-manager.nixosModules.home-manager
            ];

            home-manager.extraSpecialArgs = inputs // {
              inherit system;
              inherit
                user
                home
                dots_path
                pkgs
                ;

              users."${user}" = import ./home.nix;
              backupFileExtension = "hm-bak";
            };
          }
        ];
      };
    };
}
