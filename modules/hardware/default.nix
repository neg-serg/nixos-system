{
  lib,
  config,
  pkgs,
  ...
}: let
  auto = config.hardware.storage.autoMount;
in {
  options.hardware.storage.autoMount.enable =
    lib.mkEnableOption "Enable removable-media auto-mount via devmon (udisks2).";
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
    # Gate devmon behind a host-togglable flag; default remains off
    devmon.enable = lib.mkDefault (auto.enable or false);
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
