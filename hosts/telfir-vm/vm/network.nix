{lib, ...}: {
  # Align with qemu-vm module: disable timesyncd to avoid conflicts
  services.timesyncd.enable = lib.mkForce false;

  # Basic DHCP for any interface; no bridges in VM
  networking.firewall.enable = false;
  networking.hostName = lib.mkForce "telfir-vm";
  systemd.network.networks."99-vm-default" = {
    matchConfig.Name = "*";
    networkConfig.DHCP = "ipv4";
  };
}
