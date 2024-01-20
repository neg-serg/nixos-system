{
    description = "Neg-Serg configuration";
    inputs = {
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        disko.url = "github:nix-community/disko";
        nh.url = "github:viperML/nh";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nix-ld.url = "github:Mic92/nix-ld";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        nur.url = "github:nix-community/NUR";
    };
    outputs = {
        self
        , chaotic
        , disko
        , nh
        , nix
        , nix-gaming
        , nix-ld
        , nixos-hardware
        , nixpkgs
        , nixpkgs-stable
        , nixtheplanet
        , nur
        } @inputs: 
        let system = "x86_64-linux"; in {
        nixosConfigurations = {
            telfir = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {inherit inputs;};
                modules = [
                    ./configuration.nix
                    chaotic.nixosModules.default
                    nix-gaming.nixosModules.pipewireLowLatency
                ];
            };
        };
    };
}
