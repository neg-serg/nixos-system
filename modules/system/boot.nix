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
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkForce false;
        memtest86.enable = true;
        consoleMode = "auto";
        edk2-uefi-shell.enable = true;
      };
      grub = {
        backgroundColor = "#000000";
        device = "nodev";
        efiSupport = true;
        enable = false;
        font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF-Bold.ttf";
        fontSize = 32;
        gfxmodeEfi = "2560x1440";
        gfxpayloadEfi = "keep";
        memtest86.enable = true;
        splashImage = null;
        useOSProber = true;
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
