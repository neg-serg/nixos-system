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
                fontSize = 48;
                gfxmodeEfi = "2560x1440";
                gfxpayloadEfi = "keep";
                splashImage = /home/neg/pic/wl/4305db796f7d8fcb41b27df23912358c.jpg;
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
