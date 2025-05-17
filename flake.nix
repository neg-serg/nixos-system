{
  description = "Neg-Serg configuration";
  inputs = {
    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-flatpak = { url = "github:gmodena/nix-flatpak"; }; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    lix-module = { url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    raise = { url = "github:knarkzel/raise"; };
  };
  outputs = inputs @ {
    self,
    lix-module,
    lanzaboote,
    nh,
    nix,
    nix-flatpak,
    nix-gaming,
    nixos-hardware,
    nixpkgs,
    raise,
    chaotic,
  }:
    with {
      locale = "en_US.UTF-8"; # select locale
      system = "x86_64-linux";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
    }; {
      packages.${system}.default = nixpkgs.legacyPackages.${system}.zsh;
      nixosConfigurations = {
        telfir = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit locale;
            inherit timeZone;
            inherit kexec_enabled;
            inherit inputs;
          };
          modules = [
            ./init.nix
            ./cachix.nix
            lix-module.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
          ];
        };
      };
    };
}
