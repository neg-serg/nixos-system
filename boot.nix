{ config, lib, pkgs, modulesPath, packageOverrides, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot = {
                consoleMode = "max";
                editor = false; # close security hole
                enable = true;
            };
            timeout = 3;
        };
        plymouth.enable = true;
        kernelPackages = pkgs.linuxPackages_cachyos;
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
