{ config, pkgs, ... }:
{
    services.xserver = {
        enable = true; # Enable the X11 windowing system.
        exportConfiguration = true;
        layout = "us,ru";
        autoRepeatDelay = 250;
        autoRepeatInterval = 20;
        xkbVariant = "";
        xkbOptions = "grp:alt_shift_toggle";
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        displayManager = {
            defaultSession = "negwm";
            autoLogin.enable = true;
            autoLogin.user = "neg";
            session = [{manage="desktop"; name="negwm"; start=''$HOME/.xsession'';}];
            lightdm = {
                greeters.mini = {
                    enable = true;
                    user = "neg";
                    extraConfig = ''
                        [greeter]
                        show-password-label = true
                        password-label-text = Welcome home, great slayer
                        invalid-password-text = Are you sure?
                        show-input-cursor = false
                        password-alignment = left

                        [greeter-theme]
                        font = "Iosevka Regular"
                        font-size = 14pt
                        text-color = "#666666"
                        error-color = "#FF0000"
                        background-image = "/home/neg/pic/wl/wallhaven-wewqop.jpg"
                        background-color = "#000000"
                        window-color = "#000000"
                        border-color = "#333333"
                        border-width = 1px
                        layout-space = 14
                        password-color = "#666666"
                        password-background-color = "#222222"
                        '';
                };
            };
        };
    };
}
