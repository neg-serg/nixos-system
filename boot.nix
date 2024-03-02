{ pkgs, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot = {
                consoleMode = "max";
                editor = false; # close security hole
                enable = true;
            };
            timeout = 1;
        };
        kernelPackages = pkgs.linuxPackages_cachyos-lto;
        initrd = {
            availableKernelModules = [
                "nvidia"
                "nvidia_drm"
                "nvidia_modeset"
                "nvidia_uvm"
                "nvme"
                "sd_mod"
                "usb_storage"
                "usbhid"
                "xhci_hcd"
                "xhci_pci"
            ];
            kernelModules = [
                "dm-snapshot"
            ];
        };
    };
}
