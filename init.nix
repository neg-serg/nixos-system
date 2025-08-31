# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ self, ... }: {
  imports = [./modules];
  system = {
    stateVersion = "23.11"; # (man configuration.nix or on https://nixos.org/nixos/options.html).
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
    # Track this flake and update nixpkgs on upgrades
    autoUpgrade.flake = "${self}#telfir";
    autoUpgrade.flags = [
      "--update-input" "nixpkgs"
      "--commit-lock-file"
    ];
  };
}
