{ config, pkgs, ... }:
let tokyo-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm/default.nix { }; in {
    environment.systemPackages = with pkgs; [tokyo-night-sddm];
    services.xserver = {
        enable = true; # Enable the X11 windowing system.
        enableCtrlAltBackspace = true;
        exportConfiguration = true;
        layout = "us,ru";
        autoRepeatDelay = 250;
        autoRepeatInterval = 20;
        xkbVariant = "";
        xkbOptions = "grp:alt_shift_toggle";
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        desktopManager = { xterm.enable = false; };
        displayManager = {
            defaultSession = "none+i3";
            autoLogin.enable = false;
            autoLogin.user = "neg";
            session = [{
                manage="window";
                name="i3";
                start=''$HOME/.xsession'';
            }];
            sddm = {
                enable = true;
                wayland.enable = false;
                settings = {
                    General = {
                        DisplayServer = "x11-user";
                    };
                };
            };
        };
    };
}
