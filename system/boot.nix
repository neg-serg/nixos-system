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
        enable = true;
        efiSupport = true;
        useOSProber = true;
        memtest86.enable = true;
        device = "nodev";
        backgroundColor = "#000000";
        font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF-Bold.ttf";
        fontSize = 32;
        gfxmodeEfi = "2560x1440";
        gfxpayloadEfi = "keep";
        darkmatter-theme = {
          enable = true;
          style = "nixos";
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
