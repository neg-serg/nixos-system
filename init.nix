# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  imports = [./system ./hardware ./nix ./user ./pkgs];
  system = {
    stateVersion = "23.11"; # (man configuration.nix or on https://nixos.org/nixos/options.html).
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
  };
}
