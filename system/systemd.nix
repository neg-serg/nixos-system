{ pkgs, ... }: {
    systemd = {
        coredump.enable = true;
        extraConfig = '' DefaultTimeoutStopSec=10s '';
        watchdog.rebootTime = "0";
        packages = [ pkgs.packagekit ];
    };
}
