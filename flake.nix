{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      # Pin Hyprland to a known-stable tag compatible with hy3
      url = "github:hyprwm/Hyprland?ref=v0.50.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Keep Hyprland-related inputs in lockstep with the pinned Hyprland flake
    hyprland-protocols.follows = "hyprland/hyprland-protocols";
    hyprland-qtutils.follows = "hyprland/hyprland-qtutils";
    # qt-support is nested under hyprland-qtutils
    hyprland-qt-support.follows = "hyprland/hyprland-qtutils/hyprland-qt-support";
    # xdg-desktop-portal-hyprland is named 'xdph' in Hyprland's flake inputs
    xdg-desktop-portal-hyprland.follows = "hyprland/xdph";
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
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
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
      # Official NixOS cache (required for cache.nixos.org)
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      # Garnix cache
      "cache.garnix.io-1:CTFPyK8EEhZ3jAC5vVsQt1zArhcXd1LSeX776BFqe7A="
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
    ...
  }:
    with {
      locale = "en_US.UTF-8"; # select locale
      system = "x86_64-linux";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
      diffClosures = import ./modules/diff-closures.nix;
    }; {
      # Option docs (markdown) for base profiles and roles
      packages.${system} = let
        pkgs = nixpkgs.legacyPackages.${system};
        # Use nixpkgs.lib to access nixosOptionsDoc if available
        lib = nixpkgs.lib;
        evalBase = lib.evalModules {
          inherit lib;
          modules = [
            ./modules/profiles/services.nix
            ./modules/system/profiles/security.nix
            ./modules/system/profiles/performance.nix
            ./modules/system/profiles/vm.nix
            ./modules/system/net/bridge.nix
          ];
          specialArgs = {
            inherit self inputs locale timeZone kexec_enabled;
            pkgs = pkgs;
          };
        };

        evalRoles = lib.evalModules {
          inherit lib;
          modules = [ ./modules/roles ];
          specialArgs = { inherit self inputs; pkgs = pkgs; };
        };

        hasOptionsDoc = lib ? nixosOptionsDoc;
        docsBase = if hasOptionsDoc then lib.nixosOptionsDoc { options = evalBase.options; } else null;
        docsRoles = if hasOptionsDoc then lib.nixosOptionsDoc { options = evalRoles.options; } else null;
      in
        {
          default = pkgs.zsh;
        }
        // lib.optionalAttrs hasOptionsDoc {
          options-base-md = docsBase.optionsCommonMark;
          options-roles-md = docsRoles.optionsCommonMark;
        };

      # Make `nix fmt` behave like in home-manager: format repo with alejandra
      formatter.${system} = let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.writeShellApplication {
          name = "fmt";
          runtimeInputs = [pkgs.alejandra];
          text = ''
            set -euo pipefail
            alejandra -q .
          '';
        };

      # Lightweight repo checks for `nix flake check`
      checks.${system} = let
        pkgs = nixpkgs.legacyPackages.${system};
        preCommit = inputs.pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      in {
        fmt-alejandra =
          pkgs.runCommand "fmt-alejandra" {
            nativeBuildInputs = [pkgs.alejandra];
          } ''
            cd ${self}
            alejandra -q --check .
            touch "$out"
          '';

        lint-deadnix =
          pkgs.runCommand "lint-deadnix" {
            nativeBuildInputs = [pkgs.deadnix];
          } ''
            cd ${self}
            deadnix --fail .
            touch "$out"
          '';

        lint-statix =
          pkgs.runCommand "lint-statix" {
            nativeBuildInputs = [pkgs.statix];
          } ''
            cd ${self}
            statix check .
            touch "$out"
          '';
        pre-commit = preCommit;
      };

      # Developer shell
      devShells.${system}.default = let
        pkgs = nixpkgs.legacyPackages.${system};
        preCommit = inputs.pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      in
        pkgs.mkShell {
          inherit (preCommit) shellHook;
          packages = [
            pkgs.alejandra
            pkgs.deadnix
            pkgs.statix
            pkgs.nil
          ];
        };

      nixosConfigurations = {
        telfir = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit locale;
            inherit timeZone;
            inherit kexec_enabled;
            inherit self;
            inherit inputs;
          };
          modules = [
            ./init.nix
            ./hosts/telfir
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops
            diffClosures
            {diffClosures.enable = true;}
          ];
        };
        telfir-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit locale;
            inherit timeZone;
            inherit kexec_enabled;
            inherit self;
            inherit inputs;
          };
          modules = [
            ./init.nix
            ./hosts/telfir-vm
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops
            # VM-specific adjustments
            ({lib, ...}: {
              # Avoid secure boot integration in quick VM builds
              boot.lanzaboote.enable = lib.mkForce false;
            })
          ];
        };
      };
    };
}
