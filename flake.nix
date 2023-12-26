{
    description = "Neg-Serg configuration";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        nh.url = "github:viperML/nh";
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
