# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{self, ...}: {
  imports = [./modules];
  system = {
    stateVersion = "23.11"; # (man configuration.nix or on https://nixos.org/nixos/options.html).
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      # Track this flake and update nixpkgs on upgrades
      flake = "${self}#telfir";
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
      ];
      # Schedule nightly window with randomized delay; catch-up after downtime
      dates = "03:30"; # local time
      randomizedDelaySec = "45min";
      persistent = true;
    };
  };
}
