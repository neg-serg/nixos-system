{
    services.xserver = {
        enable = true; # Enable the X11 windowing system.
        enableCtrlAltBackspace = true;
        exportConfiguration = true;
        autoRepeatDelay = 250;
        autoRepeatInterval = 20;
        xkb ={
            variant = "";
            options = "grp:alt_shift_toggle";
            layout = "us,ru";
        };
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        desktopManager = {
            plasma5.enable = true;
            xterm.enable = false; 
        };
        displayManager = {
            sddm.enable = true;
            defaultSession = "none+i3";
            autoLogin.enable = false;
            autoLogin.user = "neg";
            startx.enable = true;
            session = [{
                manage="window";
                name="i3";
                start=''$HOME/.xsession'';
            }];
        };
    };
}
