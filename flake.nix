{
  description = "Dotfiles and Work setup";

  inputs = {
    # Core channels
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR and Plover
    nurpkgs.url = "github:nix-community/NUR";
    plover.url = "github:openstenoproject/plover-flake";

    # Work flake as opaque input
    work-flake = {
      url = "path:./work";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nurpkgs,
      plover,
      work-flake,
      ...
    }:
    let
      system = "x86_64-linux";

      # Overlays common to all flakes
      overlays = [
        nurpkgs.overlays.default
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
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
        (import ./pkgs { inherit lib pkgs inputs; })
      ];

      # Common package set
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      };

      # Common library
      lib = import ./lib {
        inherit system inputs pkgs;
        inherit (user_data) dots_path;
      };

      # User data
      user_data = {
        user = "danielefongo";
        home = "/home/danielefongo";
        dots_path = "/home/danielefongo/dots";
      };
    in
    {
      inherit
        pkgs
        lib
        overlays
        user_data
        ;

      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      # Home Manager configuration
      homeConfigurations.${user_data.user} = pkgs.lib.homeManagerConfiguration {
        inherit pkgs lib;
        extraSpecialArgs = { inherit self inputs user_data; };
        modules = [ ./home.nix ];
      };

      # NixOS system configuration
      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        inherit system pkgs lib;
        specialArgs = {
          inherit self inputs user_data;
          inherit (user_data) user home dots_path;
        };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };

      # Expose Work flake outputs
      workSystemConfigs = work-flake.systemConfigs;
      workHomeModule = work-flake.homeModule;
    };
}
