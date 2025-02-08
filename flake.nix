{
  description = "Neg-Serg configuration";
  inputs = {
    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-flatpak = { url = "github:gmodena/nix-flatpak"; }; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    lix-module = { url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # nixpkgs-oldstable.url = "github:NixOS/nixpkgs/nixos-23.11-small";
    # nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    nixpkgs-master,
    nixpkgs-stable,
    nixpkgs-unstable,
    # chaotic,
    # nixos-generators,
    # nixpkgs-oldstable,
    # nixtheplanet,
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
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            master = import nixpkgs-master {
              inherit system;
              config.allowUnfree = true;
            };
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
            # oldstable = import nixpkgs-oldstable {
            #   inherit system;
            #   config.allowUnfree = true;
            # };
            inherit inputs;
          };
          modules = [
            ./init.nix
            ./cachix.nix
            lix-module.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            lanzaboote.nixosModules.lanzaboote
          ];
        };
      };
    };
}
