{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xorg.xdpyinfo # display info
    xorg.xhost # install xhost to setup X11 ACL
  ];
  services = {
    accounts-daemon.enable = true; # AccountsService a DBus service for accessing the list of user accounts and info…
    gnome = {gnome-keyring.enable = true;};
    gvfs.enable = true;
    dbus.implementation = "broker";
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    xserver = {
      enable = true; # Enable the X11 windowing system.
      exportConfiguration = true;
      autoRepeatDelay = 250;
      autoRepeatInterval = 20;
      xkb = {
        variant = "";
        options = "grp:alt_shift_toggle";
        layout = "us,ru";
      };
      desktopManager = {xterm.enable = false;};
      displayManager = {
        startx.enable = true;
        session = [
          {
            manage = "window";
            name = "i3";
            start = ''$HOME/.xsession'';
          }
        ];
      };
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = false;
        user = "neg";
      };
    };
  };
}
