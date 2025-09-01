{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keymapviz # visualize QMK keymap.c
    qmk_hid # CLI for interacting with QMK devices over HID
    qmk # QMK Firmware helper
    qmk-udev-rules # add QMK udev rules
  ];
}
