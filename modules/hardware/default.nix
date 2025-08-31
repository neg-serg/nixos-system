{
  lib,
  config,
  pkgs,
  ...
}: {
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
  services = {
    udisks2.enable = true;
    upower.enable = true;
    devmon.enable = true; # auto-mount removable media via udisks2
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
}
