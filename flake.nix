{
    description = "Neg-Serg configuration";
    inputs = {
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        disko.url = "github:nix-community/disko";
        nh.url = "github:viperML/nh";
        nix-gaming.url = "github:fufexan/nix-gaming";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs.url = "github:NixOS/nixpkgs/master";
        nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
        nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
        darkmatter-grub-theme = { url = "gitlab:VandalByte/darkmatter-grub-theme"; inputs.nixpkgs.follows = "nixpkgs"; };
        musnix  = { url = "github:musnix/musnix"; };
    };
    outputs = {
        self
        , chaotic
        , disko
        , nh
        , nix
        , nix-gaming
        , nixos-hardware
        , nixpkgs
        , nixpkgs-stable
        , nixtheplanet
        , nixos-generators
        , darkmatter-grub-theme
        , musnix
        } @inputs:
        with rec {
            locale = "en_US.UTF-8"; # select locale
            system = "x86_64-linux";
            timeZone = "Europe/Moscow";
            kexec_enabled = true;
            stable = nixpkgs-stable.legacyPackages.${system};
        }; {
        packages.${system}.default = nixpkgs.legacyPackages.${system}.zsh;
        nixosConfigurations = {
            telfir = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                    inherit locale;
                    inherit timeZone;
                    inherit kexec_enabled;
                    inherit stable;
                };
                specialArgs = {inherit inputs;};
                modules = [
                    ./configuration.nix
                    ./cachix.nix
                    musnix.nixosModules.musnix
                    chaotic.nixosModules.default
                    darkmatter-grub-theme.nixosModule
                ];
            };
        };
    };
}
