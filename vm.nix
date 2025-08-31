{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Provide virtualisation.* options (cores, memorySize, diskSize, qemu.*)
    "${pkgs.path}/nixos/modules/virtualisation/qemu-vm.nix"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  virtualisation = {
    cores = 2;
    diskSize = 10 * 1024;
    memorySize = 4 * 1024;
    qemu = {
      # networkingOptions = ["-nic bridge,br=br0,model=virtio-net-pci,helper=/run/wrappers/bin/qemu-bridge-helper"];
      options = ["-bios" "${pkgs.OVMF.fd}/FV/OVMF.fd"];
    };
  };
  environment.systemPackages = with pkgs; [
    nemu # qemu tui interface
  ];
  networking.firewall.enable = false; # for user convenience

  # Make the VM identifiable and online by default
  networking.hostName = lib.mkDefault "telfir-vm";
  systemd.network.networks."99-vm-default" = {
    matchConfig.Name = "*";
    networkConfig.DHCP = "ipv4";
  };

  # Enable removable media auto-mount in the VM for convenience/testing
  hardware.storage.autoMount.enable = true;
}
