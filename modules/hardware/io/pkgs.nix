{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    blktrace # block layer tracing tools
    dmraid # old-style RAID config utility
    exfat # exFAT libs
    exfatprogs # exFAT utilities
    fio # disk benchmark
    gptfdisk # sgdisk and friends
    ioping # IO latency measuring tool
    mtools # MS-DOS disk utilities
    multipath-tools # kpartx, etc. for images
    nvme-cli # NVMe management tools
    ostree # Git for OS binaries
    parted # CLI disk manager
    smartmontools # smartctl
  ];
}
