{ pkgs, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            # systemd-boot = {
            #     consoleMode = "max";
            #     editor = false; # close security hole
            #     enable = true;
            # };
            grub.enable = true;
            grub.version = 2;
            grub.efiSupport = true;
            grub.useOSProber = true;
            grub.device = "nodev";
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
