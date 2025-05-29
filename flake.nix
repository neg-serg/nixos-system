{
  description = "Neg-Serg configuration";
  inputs = {
    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
    determinate = { url = "https://flakehub.com/f/DeterminateSystems/determinate/*"; };
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-flatpak = { url = "github:gmodena/nix-flatpak"; }; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprland = { url = "github:hyprwm/Hyprland"; };
    raise = { url = "github:knarkzel/raise"; };
  };
  outputs = inputs @ {
    self,
    lanzaboote,
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
