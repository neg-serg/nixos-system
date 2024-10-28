{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vial # gui configuration for qmk-based keyboards
    qmk-udev-rules # add qmk udev rules
  ];
}
