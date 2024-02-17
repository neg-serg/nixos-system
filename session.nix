{ pkgs, ... }:
let tokyo-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm/default.nix { }; in {
    environment.systemPackages = with pkgs; [tokyo-night-sddm];
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
        desktopManager = { xterm.enable = false; };
        displayManager = {
            defaultSession = "none+i3";
            autoLogin.enable = false;
            autoLogin.user = "neg";
            startx.enable = true;
            session = [{
                manage="window";
                name="i3";
                start=''$HOME/.xsession'';
            }];
            sddm = {
                enable = true;
                theme = "tokyo-night-sddm";
                wayland.enable = true;
                settings = {
                    General = { DisplayServer = "x11-user"; };
                };
            };
        };
    };
}
