{pkgs, master, ...}: {
  environment.systemPackages = with pkgs; [
    blktrace # another disk test
    dmraid # Old-style RAID configuration utility
    exfat # exfat libs
    exfatprogs # Exfat support
    fio # disk test
    gptfdisk # sgdisk
    ioping # io latency measuring tool
    master.vial # add vial to configure keyboards
    mtools # utils for msdos disks
    multipath-tools # (kpartx) create loop devices for partitions in image
    nvme-cli # nvme manage tools
    ostree # git for os binaries
    parted # cli disk manager
    smartmontools # smartctl
  ];
}
