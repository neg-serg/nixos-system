{
  imports = [
    ./boot.nix
    ./environment.nix
    ./filesystems.nix
    ./kernel.nix
    ./profiles/performance.nix
    ./net
    ./oomd.nix
    ./pkgs.nix
    ./systemd
    ./users.nix
    ./virt.nix
  ];
}
