{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        btop # even more fancy top
        dstat # example use: dstat -cdnpmgs --top-bio --top-cpu --top-mem
        htop # fancy top
        iotop # top for iops
        iperf iperf2 # IP bandwidth measurement
        linuxKernel.packages.linux_6_8.perf
        linuxKernel.packages.linux_6_8.turbostat # cpu monitor
        nethogs # network traffic per process
        powertop # watch for power events
        procdump # procdump for linux
        scx # for cachyos sched
        sysstat # sar, iostat, mpstat, pidstat and friends
        vmtouch # portable file system cache diagnostics and control
    ];
}
