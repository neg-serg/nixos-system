{
  imports = [
      ./boot.nix
      ./filesystems.nix
      ./kernel.nix

      ./appimage.nix
      ./keyd.nix # systemwide keyboard manager
      ./networking.nix
      ./systemd.nix
      ./udev-rules.nix
      ./vnstat.nix
  ];
}
