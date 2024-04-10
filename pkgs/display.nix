{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        ddccontrol # ddc control
        ddcutil # rule monitor params
        edid-decode # edid decoder and tester
        read-edid # tool to read and parse edid from monitors
        xcalib # stuff for icc profiles
    ];
}
