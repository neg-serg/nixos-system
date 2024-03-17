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
