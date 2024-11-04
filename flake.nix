{
  description = "Neg-Serg configuration";
  inputs = {
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nh.url = "github:viperML/nh";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixpkgs-oldstable.url = "github:NixOS/nixpkgs/nixos-23.05-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    dedsec-grub-theme = {
      url = "gitlab:VandalByte/dedsec-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    lix-module = { url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz"; inputs.nixpkgs.follows = "nixpkgs"; };
  };
  outputs = inputs @ {
    self,
    # chaotic,
    dedsec-grub-theme,
    lix-module,
    nh,
    nix,
    nix-flatpak,
    nix-gaming,
    # nixos-generators,
    nixos-hardware,
    nixpkgs,
    # nixpkgs-master,
    nixpkgs-oldstable,
    nixpkgs-stable,
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
            oldstable = import nixpkgs-oldstable {
              inherit system;
              config.allowUnfree = true;
            };
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            # master = import nixpkgs-master {
            #   inherit system;
            #   config.allowUnfree = true;
            # };
            inherit inputs;
          };
          modules = [
            ./init.nix
            ./cachix.nix
            lix-module.nixosModules.default
            # chaotic.nixosModules.default
            dedsec-grub-theme.nixosModule
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}
