{
  description = "Chalkan3 NixOS Flake - Modular Configuration";

  inputs = {
    # NixOS stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # NixOS unstable for bleeding edge packages
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utils
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, ... }@inputs:
    let
      # Supported systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate attrs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs config
      nixpkgsConfig = {
        allowUnfree = true;
      };

      # Create pkgs for a system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      };

      # Unstable packages overlay
      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config = nixpkgsConfig;
        };
      };

      # Custom lib extensions
      lib = nixpkgs.lib.extend (final: prev: {
        chalkan = import ./lib { lib = final; };
      });

    in {
      # NixOS configurations
      nixosConfigurations = {
        # Chalkan3 - LXC Container (x86_64)
        chalkan3 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Hardware/platform specific
            ./hosts/chalkan3/configuration.nix

            # Home Manager as NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.root = import ./hosts/chalkan3/home.nix;
              };
            }

            # Global NixOS modules
            ./modules/nixos
          ];
        };

        # Chalkan3 - LXC Container/VM (aarch64)
        chalkan3-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Hardware/platform specific
            ./hosts/chalkan3/configuration.nix

            # Home Manager as NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.root = import ./hosts/chalkan3/home.nix;
              };
            }

            # Global NixOS modules
            ./modules/nixos
          ];
        };
      };

      # Development shells
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixpkgs-fmt
              nil
              statix
            ];
          };
        }
      );

      # Formatter
      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);
    };
}
