{ config, lib, pkgs, modulesPath, packageOverrides, ... }:
{
    boot.kernelPackages = pkgs.linuxPackages_cachyos-sched-ext;
    boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.consoleMode = "max";
        systemd-boot.editor = false; # close security hole
        systemd-boot.enable = true;
        timeout = 3;
    };
    boot.initrd = {
        availableKernelModules = [
            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvme"
            "sd_mod"
            "usbhid"
            "usb_storage"
            "xhci_hcd"
            "xhci_pci"
        ];
        kernelModules = ["dm-snapshot"];
    };
}
