{
    services.udev.extraRules = ''
        # High performance clocks for audio
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
    '';
}
