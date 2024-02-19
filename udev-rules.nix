{
    services.udev.extraRules = ''
        # High performance clocks for audio
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
    '';
}
