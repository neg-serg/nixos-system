{
  imports = [
    ./boot.nix
    ./environment.nix
    ./filesystems.nix
    ./kernel.nix
    ./profiles/security.nix
    ./profiles/performance.nix
    ./net
    ./oomd.nix
    ./irqbalance.nix
    ./zram.nix
    ./pkgs.nix
    ./systemd
    ./users.nix
    ./virt.nix
  ];
}
