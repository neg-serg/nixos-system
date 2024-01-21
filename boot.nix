{ config, lib, pkgs, modulesPath, packageOverrides, ... }: {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.consoleMode = "max";
            systemd-boot.editor = false; # close security hole
                systemd-boot.enable = true;
            timeout = 3;
        };
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
            kernelModules = ["dm-snapshot"];
        };
    };
}
