{stable, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cryptsetup # stuff for LUKS
    dmidecode # extract system/memory/bios info
    kexec-tools # tools related to the kexec Linux feature
    lm_sensors # sensors
    pciutils # manipulate pci devices
    stable.schedtool # CPU scheduling
    usbutils # lsusb
  ];
}
