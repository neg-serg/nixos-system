{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  virtualisation = {
    cores = 2;
    diskSize = 10 * 1024;
    memorySize = 4 * 1024;
    qemu = {
      # networkingOptions = ["-nic bridge,br=br0,model=virtio-net-pci,helper=/run/wrappers/bin/qemu-bridge-helper"];
      options = [ "-bios" "${pkgs.OVMF.fd}/FV/OVMF.fd" ];
    };
  };
  networking.firewall.enable = false; # for user convenience
}
