{
  lib,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr # rule efi boot
    efivar # manipulate efi vars
    os-prober # utility to detect other OSs on a set of drives
    sbctl # For debugging and troubleshooting Secure Boot.
  ];
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      # With lanzaboote enabled, ensure systemd-boot is explicitly disabled
      # and avoid setting unrelated systemd-boot options that would be ignored.
      systemd-boot.enable = lib.mkForce false;
    };
    # boot-specific options only; activation script moved to top-level system.*
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

  # Ensure the boot loader (systemd-boot via lanzaboote) uses the highest
  # available GOP console mode so the menu/early boot is in 4K.
  # We set this via an activation script (top-level system.*) to avoid relying on
  # boot.loader.systemd-boot.* options that are intentionally disabled here.
  system.activationScripts.setBootConsoleMode = {
    deps = ["specialfs"]; # ensure /boot is mounted
    text = let
      esp = config.boot.loader.efi.efiSysMountPoint or "/boot";
    in ''
      set -eu
      esp_path='${esp}'
      if [ -d "$esp_path" ]; then
        mkdir -p "$esp_path/loader"
        conf="$esp_path/loader/loader.conf"
        # Remove any existing console-mode lines (case-insensitive)
        if [ -f "$conf" ]; then
          awk 'BEGIN{IGNORECASE=1} !/^console-mode[[:space:]]/ {print}' "$conf" > "$conf.tmp"
          mv "$conf.tmp" "$conf"
        else
          : > "$conf"
        fi
        # Force highest available text mode in systemd-boot
        printf '%s\n' 'console-mode max' >> "$conf"
      fi
    '';
  };
}
