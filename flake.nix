{
    description = "Neg-Serg configuration";
    inputs = {
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        disko.url = "github:nix-community/disko";
        nh.url = "github:viperML/nh";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        nur.url = "github:nix-community/NUR";
        nix-ld.url = "github:Mic92/nix-ld";
    };
    outputs = {
        self
        , nix
        , nixos-hardware
        , nixpkgs
        , nixpkgs-stable
        , nix-gaming
        , nixtheplanet
        , chaotic
        , nh
        , nur
        , disko
        , nix-ld
        } @inputs: {
        nixosConfigurations = {
            telfir = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    chaotic.nixosModules.default
                    nix-gaming.nixosModules.pipewireLowLatency
                    agenix.nixosModules.default { environment.systemPackages = [ agenix.packages."x86_64-linux".default ]; }
                ];
            };
        };
    };
}
