{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.ddccontrol # ddc control
    pkgs.ddcutil # rule monitor params
    pkgs.edid-decode # edid decoder and tester
    pkgs.read-edid # tool to read and parse edid from monitors
  ];
}
