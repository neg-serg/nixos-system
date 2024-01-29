{ config, lib, pkgs, modulesPath, packageOverrides, inputs, ... }: {
    environment.systemPackages = with pkgs; [
        # hddtemp # display hard disk temperature
        # hdparm # set ata/sata params
        # pam_u2f  # A PAM module for allowing authentication with a U2F device
        # flatpak-builder # build flatpaks
        # hashcat # password recovery
        # qFlipper # desktop stuff for flipper zero
    ];
}
