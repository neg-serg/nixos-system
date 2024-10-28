{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr # rule efi boot
    efivar # manipulate efi vars
    os-prober # utility to detect other OSs on a set of drives
  ];
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        backgroundColor = "#000000";
        device = "nodev";
        efiSupport = true;
        enable = true;
        font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF-Bold.ttf";
        fontSize = 32;
        gfxmodeEfi = "2560x1440";
        gfxpayloadEfi = "keep";
        memtest86.enable = true;
        splashImage = null;
        useOSProber = true;
        dedsec-theme = {
          enable = true;
          style = "compact";
          icon = "color";
          resolution = "1440p";
        };
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
