{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keymapviz # qmk keymap.c visualizer
    qmk_hid # commandline tool for interactng with QMK devices over HID 
    qmk # program to help users work with QMK Firmware
    qmk-udev-rules # add qmk udev rules
  ];
}
