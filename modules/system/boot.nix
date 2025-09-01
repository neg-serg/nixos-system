##
# Module: system/boot
# Purpose: Bootloader (EFI, lanzaboote), initrd modules.
# Key options: none (uses config.boot.* directly).
# Dependencies: pkgs (efibootmgr/efivar/os-prober/sbctl), lanzaboote.
{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [ ./boot/pkgs.nix ];
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      # With lanzaboote enabled, default systemd-boot to disabled; hosts may override.
      systemd-boot.enable = lib.mkDefault false;
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
