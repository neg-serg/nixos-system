{lib, pkgs, ...}: {
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
     settings = {
       memtest86 = true;
       edk2-uefi-shell = true;
       consoleMode = "max";
     };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkForce false;
      };
      timeout = 1;
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
