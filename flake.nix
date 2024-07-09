{
  description = "My home manager dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { nixpkgs, nixgl, home-manager, ... } @inputs:
    let
      system = "x86_64-linux";
      user = "danielefongo";
      home = "/home/danielefongo";
      dots_path = "/home/danielefongo/dotfiles/dots";

      pkgs = (nixpkgs.legacyPackages.${system}).extend (nixpkgs.lib.composeManyExtensions [
        nixgl.overlay
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
      ]);

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
    };
}
