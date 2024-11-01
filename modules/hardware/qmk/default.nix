{pkgs, lib, config, ...}: with {
  not_main = lib.mkIf (config.networking.hostName != "telfir");
}; {
  environment.systemPackages = with pkgs; not_main [
    vial # gui configuration for qmk-based keyboards
    qmk-udev-rules # add qmk udev rules
  ];
}
