{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        # hddtemp # display hard disk temperature
        # hdparm # set ata/sata params
        # flatpak-builder # build flatpaks
        # hashcat # password recovery
        # qFlipper # desktop stuff for flipper zero
    ];
}
