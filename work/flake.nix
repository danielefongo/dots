{
  description = "Work-specific extensions";

  inputs = {
    # System Manager only for work
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Work private inputs
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    suite_py = {
      url = "git+ssh://git@github.com/primait/suite_py";
    };
    prima-nix = {
      url = "git+ssh://git@github.com/primait/prima.nix.git";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      system-manager,
      nixgl,
      suite_py,
      prima-nix,
      ...
    }:
    let
      system = "x86_64-linux";

      # Overlays specific to work
      extraOverlays = [
        nixgl.overlay
        suite_py.overlays.default
        (import ./pkgs {
          inherit
            nixpkgs
            nixgl
            suite_py
            prima-nix
            ;
        })
      ];

      workPkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays;
      };
    in
    {
      # System Manager config for Work
      systemConfigs = {
        default = system-manager.lib.makeSystemConfig {
          inherit workPkgs;
          extraSpecialArgs = { inherit self system workPkgs; };
          modules = [ ./system.nix ];
        };
      };

      # Home Manager module for Work
      homeModule = {
        imports = [ ./home.nix ];
      };
    };
}
