{stable, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr # rule efi boot
    efivar # manipulate efi vars
    stable.os-prober # utility to detect other OSs on a set of drives
    sbctl # For debugging and troubleshooting Secure Boot.
  ];
  boot = {
    #lanzaboote = {
    #  enable = true;
    #  pkiBundle = "/etc/secureboot";
    #};
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        #enable = lib.mkForce false;
	enable = true;
        memtest86.enable = true;
        consoleMode = "max";
        edk2-uefi-shell.enable = true;
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
