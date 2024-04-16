{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        keyd # systemwide key manager
        xorg.xdpyinfo # display info
    ];
    services.xserver = {
        enable = true; # Enable the X11 windowing system.
        enableCtrlAltBackspace = true;
        exportConfiguration = true;
        autoRepeatDelay = 250;
        autoRepeatInterval = 20;
        xkb = {
            variant = "";
            options = "grp:alt_shift_toggle";
            layout = "us,ru";
        };
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        desktopManager = { xterm.enable = false; };
        displayManager = {
            startx.enable = true;
            session = [{ manage="window"; name="i3"; start=''$HOME/.xsession''; }];
        };
    };
    services.displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
            enable = false;
            user = "neg";
        };
    };
}
