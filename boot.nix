{ pkgs, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                version = 2;
                efiSupport = true;
                useOSProber = true;
                device = "nodev";
                backgroundColor = "#000000";
                font = "${pkgs.iosevka}/share/fonts/Iosevka.ttf";
                fontSize = 48;
                gfxmodeEfi = "3440x1440";
                splashImage = /home/neg/pic/wl/4305db796f7d8fcb41b27df23912358c.jpg;
            };
            timeout = 1;
        };
        kernelPackages = pkgs.linuxPackages_cachyos;
        initrd = {
            availableKernelModules = [
                "nvme"
                "sd_mod"
                "usb_storage"
                "usbhid"
                "xhci_hcd"
                "xhci_pci"
            ];
            kernelModules = [
                "dm-snapshot"
                "amdgpu"
            ];
        };
    };
}
