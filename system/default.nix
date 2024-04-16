{
  imports = [
      ./boot.nix
      ./filesystems.nix
      ./kernel.nix
      ./environment.nix
      ./networking.nix
      ./security.nix
      ./systemd.nix
      ./users.nix

      ./appimage.nix
      ./keyd.nix # systemwide keyboard manager
      ./vnstat.nix
      ./documentation.nix
  ];
}
