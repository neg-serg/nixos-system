{ ... }:{
    musnix.enable = true;
    # musnix.kernel.realtime = true;
    # musnix.kernel.packages = pkgs.linuxPackages-rt_latest;
    musnix.rtirq.enable = true;
    musnix.rtcqs.enable = true;
    musnix.das_watchdog.enable = true;
}
