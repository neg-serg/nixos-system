{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic = { url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; };
    determinate = { url = "https://flakehub.com/f/DeterminateSystems/determinate/*"; };
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
    lanzaboote,
    determinate,
    nh,
    nix,
    nix-flatpak,
    nix-gaming,
    nixos-hardware,
    nixpkgs,
    hyprland,
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
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
            determinate.nixosModules.default
          ];
        };
      };
    };
}
