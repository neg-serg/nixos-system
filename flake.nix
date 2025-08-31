{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {url = "github:numtide/flake-utils";};
    hyprland = {
      # Pin Hyprland to a known-stable tag compatible with hy3
      url = "github:hyprwm/Hyprland?ref=v0.50.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {url = "github:gmodena/nix-flatpak";}; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {url = "github:NixOS/nixpkgs";};
    raise = {
      url = "github:knarkzel/raise";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Make Cachix caches available to all `nix {build,develop,run}` commands
  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://0uptime.cachix.org"
      "https://chaotic-nyx.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://devenv.cachix.org"
      "https://ezkea.cachix.org"
      "https://cache.garnix.io"
      "https://hercules-ci.cachix.org"
      "https://hyprland.cachix.org"
      "https://neg-serg.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://numtide.cachix.org"
    ];
    trusted-public-keys = [
      "0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "cache.garnix.io:CTFPyK8EEhZ3jAC5vVsQt1zArhcXd1LSeX776BFqe7A="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "neg-serg.cachix.org-1:MZ+xYOrDj1Uhq8GTJAg//KrS4fAPpnIvaWU/w3Qz/wo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };
  outputs = inputs @ {
    self,
    chaotic,
    lanzaboote,
    nix-flatpak,
    nixpkgs,
    sops-nix,
    flake-utils,
    ...
  }:
    let
      # Shared settings
      locale = "en_US.UTF-8";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
      diffClosures = import ./modules/diff-closures.nix;
      # Systems to build tools for
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      # Host system for NixOS configurations
      defaultSystem = "x86_64-linux";
    in
      flake-utils.lib.eachSystem systems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          # Packages
          packages.default = pkgs.zsh;

          # Formatter for `nix fmt`
          formatter = pkgs.alejandra;

          # Lightweight repo checks for `nix flake check`
          checks = {
            nix-fmt = pkgs.runCommand "check-nix-fmt" {
              nativeBuildInputs = [pkgs.alejandra];
            } ''
              cd ${self}
              alejandra --check .
              mkdir -p "$out" && echo ok > "$out/result"
            '';

            deadnix = pkgs.runCommand "check-deadnix" {
              nativeBuildInputs = [pkgs.deadnix];
            } ''
              cd ${self}
              deadnix --fail .
              mkdir -p "$out" && echo ok > "$out/result"
            '';

            statix = pkgs.runCommand "check-statix" {
              nativeBuildInputs = [pkgs.statix];
            } ''
              cd ${self}
              statix check .
              mkdir -p "$out" && echo ok > "$out/result"
            '';
          };

          # Developer shell
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.alejandra
              pkgs.deadnix
              pkgs.statix
              pkgs.nil
            ];
          };
        }) // {
        nixosConfigurations = {
          telfir = nixpkgs.lib.nixosSystem {
            system = defaultSystem;
            specialArgs = {
              inherit locale;
              inherit timeZone;
              inherit kexec_enabled;
              inherit inputs;
            };
            modules = [
              ./init.nix
              nix-flatpak.nixosModules.nix-flatpak
              lanzaboote.nixosModules.lanzaboote
              chaotic.nixosModules.default
              sops-nix.nixosModules.sops
              diffClosures
              {diffClosures.enable = true;}
            ];
          };
        };
      };
}
