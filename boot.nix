{ pkgs, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                useOSProber = true;
                device = "nodev";
                backgroundColor = "#000000";
                font = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Medium.ttf";
                fontSize = 32;
                gfxmodeEfi = "2560x1440";
                gfxpayloadEfi = "keep";
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
