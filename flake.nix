{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic = { url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
    hyprland = { url = "github:hyprwm/Hyprland"; };
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-flatpak = { url = "github:gmodena/nix-flatpak"; }; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    raise = { url = "github:knarkzel/raise"; };
  };
  outputs = inputs @ {
    self,
    chaotic,
    flake-utils,
    hyprland,
    lanzaboote,
    nh,
    nix,
    nix-flatpak,
    nix-gaming,
    nixos-hardware,
    nixpkgs,
    raise,
  }:
    with {
      locale = "en_US.UTF-8"; # select locale
      system = "x86_64-linux";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
      diffClosures = import ./modules/diff-closures.nix;
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
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
            diffClosures { diffClosures.enable = true; }
          ];
        };
      };
    };
}
