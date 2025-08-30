{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic = { url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
    hyprland = { url = "github:hyprwm/Hyprland"; inputs.nixpkgs.follows = "nixpkgs"; };
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-flatpak = { url = "github:gmodena/nix-flatpak"; }; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    raise = { url = "github:knarkzel/raise"; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = "github:Mic92/sops-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
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
    sops-nix
  }:
    with {
      locale = "en_US.UTF-8"; # select locale
      system = "x86_64-linux";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
      diffClosures = import ./modules/diff-closures.nix;
    }; {
      packages.${system}.default = nixpkgs.legacyPackages.${system}.zsh;

      # Allow `nix fmt` to format this repo
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

      # Lightweight repo checks for `nix flake check`
      checks.${system} = let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        nix-fmt = pkgs.runCommand "check-nix-fmt" {
          nativeBuildInputs = [ pkgs.alejandra ];
        } ''
          cd ${self}
          alejandra --check .
          mkdir -p $out && echo ok > $out
        '';

        deadnix = pkgs.runCommand "check-deadnix" {
          nativeBuildInputs = [ pkgs.deadnix ];
        } ''
          cd ${self}
          deadnix --fail .
          mkdir -p $out && echo ok > $out
        '';

        statix = pkgs.runCommand "check-statix" {
          nativeBuildInputs = [ pkgs.statix ];
        } ''
          cd ${self}
          statix check .
          mkdir -p $out && echo ok > $out
        '';
      };
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
            sops-nix.nixosModules.sops
            diffClosures { diffClosures.enable = true; }
          ];
        };
      };
    };
}
