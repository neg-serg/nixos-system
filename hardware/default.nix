{
  lib,
  config,
  ...
}: {
  imports = [
    ./audio
    ./libinput.nix
    ./udev-rules.nix
    ./video
  ];
  hardware.i2c.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {General.Enable = "Source,Sink,Media,Socket";};
  };
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableAllFirmware = true; # Enable all the firmware
  hardware.enableRedistributableFirmware = true;
  hardware.openrazer.enable = false; # Enable the OpenRazer driver for my Razer stuff
}
