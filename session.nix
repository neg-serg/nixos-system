{ config, pkgs, lib, ... }:
let tokyo-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm/default.nix { }; in {
    environment.systemPackages = with pkgs; [tokyo-night-sddm];
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
            defaultSession = "none+i3";
            autoLogin.enable = false;
            autoLogin.user = "neg";
            sessionCommands = ''
                ${lib.getBin pkgs.systemd}/bin/systemctl --user import-environment DISPLAY XAUTHORITY SSH_AUTH_SOCK WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP
                ${lib.getBin pkgs.dbus}/bin/dbus-daemon --session --address="unix:path=$XDG_RUNTIME_DIR/bus"
                ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
            '';
            session = [{
                manage="window";
                name="i3";
                start=''${pkgs.i3}/bin/i3 &
                        waitpid $!
                '';
            }];
            sddm = {
                enable = true;
                theme = "tokyo-night-sddm";
                wayland.enable = true;
                settings = {
                    General = {
                        DisplayServer = "x11-user";
                    };
                };
            };
        };
    };
}
