{
    description = "Neg-Serg configuration";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
    outputs = { self, nixpkgs, nix
        , nixos-hardware
        , nixpkgs-r2211 , nixpkgs-unstable
        , nix-gaming, kde2nix
        , nixtheplanet }@inputs: {
        nixosConfigurations = {
            hostname = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    pkgs-unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    pkgs-r2211 = import nixpkgs-r2211 {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    inherit nixos-hardware nix-gaming system inputs kde2nix;
                };
                modules = [
                    ./configuration.nix # Your system configuration.
                    chaotic.nixosModules.default # OUR DEFAULT MODULE
                ];
                specialArgs.inputs = inputs;
            };
        };
    };
}
