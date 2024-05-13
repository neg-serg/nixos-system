{
  description = "Neg-Serg configuration";
  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko.url = "github:nix-community/disko";
    nh.url = "github:viperML/nh";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixpkgs-oldstable.url = "github:NixOS/nixpkgs/nixos-23.05-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/staging-next";
    nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darkmatter-grub-theme = {
      url = "gitlab:VandalByte/darkmatter-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    chaotic,
    disko,
    nh,
    nix,
    nix-gaming,
    nixos-hardware,
    nixpkgs,
    nixpkgs-oldstable,
    nixpkgs-stable,
    nixpkgs-master,
    nixtheplanet,
    nixos-generators,
    darkmatter-grub-theme,
  } @ inputs:
    with rec {
      locale = "en_US.UTF-8"; # select locale
      system = "x86_64-linux";
      timeZone = "Europe/Moscow";
      kexec_enabled = true;
      oldstable = nixpkgs-stable.legacyPackages.${system};
      stable = nixpkgs-stable.legacyPackages.${system};
      master = nixpkgs-master.legacyPackages.${system};
    }; {
      packages.${system}.default = nixpkgs.legacyPackages.${system}.zsh;
      nixosConfigurations = {
        telfir = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit locale;
            inherit timeZone;
            inherit kexec_enabled;
            inherit oldstable;
            inherit stable;
            inherit master;
          };
          specialArgs = {inherit inputs;};
          modules = [
            ./init.nix
            ./cachix.nix
            chaotic.nixosModules.default
            darkmatter-grub-theme.nixosModule
          ];
        };
      };
    };
}
