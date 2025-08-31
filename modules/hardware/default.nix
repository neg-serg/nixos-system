{
  lib,
  config,
  pkgs,
  ...
}: let
  auto = config.hardware.storage.autoMount.enable or null;
in {
  options.hardware.storage.autoMount.enable = lib.mkOption {
    type = lib.types.nullOr lib.types.bool;
    default = null;
    description = "Force enable/disable devmon (removable-media auto-mount). Null keeps module default (enabled).";
    example = true;
  };

  imports = [
    ./audio
    ./cpu
    # Per-host overrides (ACPI quirks, display modes, etc.)
    ./host/telfir.nix
    ./dygma # ergonimic keyboard brand
    ./io
    ./keyd # systemwide keyboard manager
    ./qmk
    ./udev-rules
    ./video
    ./webcam
  ];

  config = {
    services = {
      udisks2.enable = true;
      upower.enable = true;
      # Default to enabled, but allow per-host override via hardware.storage.autoMount.enable
      devmon.enable =
        if auto == null
        then lib.mkDefault true
        else auto;
      fwupd.enable = true;
    };

    hardware = {
      i2c.enable = true;
      bluetooth = {
        enable = true; # disable bluetooth
        powerOnBoot = false;
        settings = {General.Enable = "Source,Sink,Media,Socket";};
      };
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      enableAllFirmware = true; # Enable all the firmware
      usb-modeswitch.enable = true; # mode switching tool for controlling 'multi-mode' USB devices.
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = with pkgs; [
      overskride # bluetooth and obex client
    ];

    powerManagement.cpuFreqGovernor = "performance";
  };
}
