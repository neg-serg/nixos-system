{
  lib,
  config,
  ...
}: {
  imports = [
    ./audio
    ./cpu
    ./dygma # ergonimic keyboard brand
    ./io
    ./keyd # systemwide keyboard manager
    ./libinput
    ./qmk
    ./udev-rules
    ./video
    ./webcam
    ./wooting
  ];
  services = {
    udisks2.enable = true;
    upower.enable = true;
    devmon.enable = true; # TODO try disable later
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

  powerManagement.cpuFreqGovernor = "performance";
}
