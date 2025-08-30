{pkgs, ...}: {
  programs = {
    atop = {enable = false;};
    mtr = {enable = true;};
  };
  environment.systemPackages = with pkgs; [
    btop # even more fancy top
    dool # example use: dool -cdnpmgs --top-bio --top-cpu --top-mem (dstat is not supported as standalone tool anymore)
    iotop # top for iops
    iperf
    iperf2 # IP bandwidth measurement
    linuxPackages_latest.perf
    linuxPackages_latest.turbostat # cpu monitor
    nethogs # network traffic per process
    powertop # watch for power events
    procdump # procdump for linux
    sysstat # sar, iostat, mpstat, pidstat and friends
    vmtouch # portable file system cache diagnostics and control
  ];
}
