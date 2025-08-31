{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr # rule efi boot
    efivar # manipulate efi vars
    os-prober # utility to detect other OSs on a set of drives
    sbctl # For debugging and troubleshooting Secure Boot.
  ];
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      # With lanzaboote enabled, ensure systemd-boot is explicitly disabled
      # and avoid setting unrelated systemd-boot options that would be ignored.
      systemd-boot.enable = lib.mkForce false;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_hcd"
        "xhci_pci"
      ];
      kernelModules = [];
    };
  };
}
