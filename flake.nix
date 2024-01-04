{
    description = "Neg-Serg configuration";
    inputs = {
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        disko.url = "github:nix-community/disko";
        nh.url = "github:viperML/nh";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        nur.url = "github:nix-community/NUR";
    };
    outputs = {
        self
        , nix
        , nixos-hardware
        , nixpkgs
        , nixpkgs-stable
        , nixpkgs-r2211
        , nix-gaming
        , nixtheplanet
        , chaotic
        , nh
        , nur
        , disko
        } @inputs: {
        nixosConfigurations = {
            telfir = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    chaotic.nixosModules.default
                ];
            };
        };
    };
}
