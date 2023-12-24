{ config, lib, pkgs, modulesPath, packageOverrides, ... }:
{
    boot.kernelPackages = pkgs.linuxPackages_cachyos-sched-ext;
    boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.consoleMode = "max";
        systemd-boot.enable = true;
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
    boot.kernelModules = ["kvm-amd"];
    boot.kernelParams = [
        "rootflags=rw,relatime,lazytime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix"

        "acpi_osi=!"
        "acpi_osi=Linux"
        "amd_iommu=on"
        "audit=0"
        "biosdevname=1"
        "cryptomgr.notests"
        "iommu=pt"
        "l1tf=off"
        "loglevel=0"
        "mds=off"
        "mitigations=off"
        "net.ifnames=0"
        "noibpb"
        "noibrs"
        "noreplace-smp"
        "nospec_store_bypass_disable"
        "nospectre_v1"
        "nospectre_v2"
        "no_stf_barrier"
        "no_timer_check"
        "nowatchdog"
        "nvidia-drm.modeset=1"
        "page_alloc.shuffle=1"
        "pcie_aspm=off"
        "quiet"
        "rcupdate.rcu_expedited=1"
        "rd.systemd.show_status=auto"
        "rd.udev.log_priority=3"
        "systemd.show_status=false"
        "threadirqs"
        "tsc=reliable"
        "vt.global_cursor_default=0"
        "preempt=full"
    ];
    boot.extraModulePackages = [];
}
