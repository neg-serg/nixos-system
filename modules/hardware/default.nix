{
  lib,
  config,
  ...
}: {
  imports = [
    ./audio
    ./io
    ./keyd # systemwide keyboard manager
    ./libinput
    ./qmk
    ./udev-rules
    ./video
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
      enable = true;
      powerOnBoot = false;
      settings = {General.Enable = "Source,Sink,Media,Socket";};
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true; # Enable all the firmware
    enableRedistributableFirmware = true;
    openrazer.enable = true; # Enable the OpenRazer driver for my Razer stuff
  };

  powerManagement.cpuFreqGovernor = "performance";
}
