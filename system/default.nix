{
  imports = [
      ./boot.nix
      ./filesystems.nix
      ./kernel.nix
      ./security.nix

      ./appimage.nix
      ./keyd.nix # systemwide keyboard manager
      ./networking.nix
      ./systemd.nix
      ./udev-rules.nix
      ./vnstat.nix
  ];
}
