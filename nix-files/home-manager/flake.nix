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

  outputs = { nixpkgs, home-manager, nixgl, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system} // {
        config.allowUnfree = true;
        overlays = [
          (self: super: {
            rebuild = super.callPackage ./pkgs/rebuild.nix { };
          })
          nixgl.overlay
        ];
      };
      user = "danielefongo";
      home = "/home/danielefongo";
    in
    {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit user;
          inherit home;
        };

        modules = [
          ./home.nix
        ];
      };
    };
}
