{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        xorg.xdpyinfo # display info
    ];
    services.desktopManager.plasma6.enable = true;
    services.xserver = {
        enable = true; # Enable the X11 windowing system.
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
        displayManager.defaultSession = "plasma";
        displayManager.sddm.wayland.enable = true;
        displayManager.sddm.enable = true;
        # displayManager = {
        #     startx.enable = true;
        #     session = [{ manage="window"; name="i3"; start=''$HOME/.xsession''; }];
        # };
    };
    # services.displayManager = {
    #     defaultSession = "none+i3";
    #     autoLogin = {
    #         enable = false;
    #         user = "neg";
    #     };
    # };
}
