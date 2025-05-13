{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    xorg.xdpyinfo # display info
    xorg.xhost # install xhost to setup X11 ACL
  ];
  programs.kdeconnect.enable = true;
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  services = {
    accounts-daemon.enable = true; # AccountsService a DBus service for accessing the list of user accounts and info…
    dbus.implementation = "broker";
    gnome = {gnome-keyring.enable = true;};
    gvfs.enable = true;
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    ratbagd.enable = true; # gaming mouse setup daemon
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
      desktopManager = {
        xterm.enable = false;
      };
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
