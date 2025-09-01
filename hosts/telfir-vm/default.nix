{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  boot = {
    # Fast-build overrides: avoid custom kernel patches/out-of-tree modules
    kernelPatches = lib.mkForce [];
    extraModulePackages = lib.mkForce [];
    # Prefer upstream latest kernel in VM
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  # Align with qemu-vm module: disable timesyncd to avoid conflicts
  services.timesyncd.enable = lib.mkForce false;

  virtualisation = {
    cores = 2;
    diskSize = 10 * 1024;
    memorySize = 4 * 1024;
    qemu = {
      options = ["-bios" "${pkgs.OVMF.fd}/FV/OVMF.fd"];
    };
  };

  environment.systemPackages = with pkgs; [
    nemu # qemu tui interface
  ];
  networking.firewall.enable = false; # for user convenience

  # Make the VM identifiable and online by default
  networking.hostName = lib.mkForce "telfir-vm";
  systemd.network.networks."99-vm-default" = {
    matchConfig.Name = "*";
    networkConfig.DHCP = "ipv4";
  };
}

