##
# Module: system/boot
# Purpose: Bootloader (EFI, lanzaboote), initrd modules.
# Key options: none (uses config.boot.* directly).
# Dependencies: pkgs (efibootmgr/efivar/os-prober/sbctl), lanzaboote.
{lib, ...}: {
  imports = [./boot/pkgs.nix];
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      # With lanzaboote enabled, default systemd-boot to disabled; hosts may override.
      systemd-boot = {
        enable = lib.mkDefault false;
        # Use the highest available UEFI console resolution (often Full HD on 1080p displays).
        # If you need exactly 1920x1080, set a numeric mode ("0".."5") that matches your firmware's 1080p mode.
        # You can try values 0–5 and pick the one that renders at 1920x1080.
        consoleMode = lib.mkDefault "max";
      };
    };
    # Boot-specific options only; no activation scripts touching /boot
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

  # Boot-time console mode script removed per request.
}
