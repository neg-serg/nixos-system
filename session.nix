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
           #autoLogin.enable = true;
           #autoLogin.user = "neg";
            sx.enable = true;
            session = [{manage="desktop"; name="negwm"; start=''$HOME/.xsession'';}];
            gdm = {
                enable = true;
                wayland = true;
                autoSuspend = false;
            };
        };
    };
}
