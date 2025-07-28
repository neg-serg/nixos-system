{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    inputs.raise.defaultPackage.${pkgs.stdenv.hostPlatform.system} # run-or-raise for hyprland
    xorg.xeyes # track eyes for the your cursor
    xorg.xhost # install xhost to setup X11 ACL
    xorg.xlsclients # show clients list
  ];
  programs.kdeconnect.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      # command = "Hyprland";
      # user = "neg";
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
      user = "greeter";
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  security.pam.services.greetd = {
    enable = true;
    enableGnomeKeyring = true;
    u2fAuth = false;
  };

  services = {
    accounts-daemon.enable = true; # AccountsService a DBus service for accessing the list of user accounts and info…
    dbus.implementation = "broker";
    gvfs.enable = true;
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    ratbagd.enable = true; # gaming mouse setup daemon
  };
}
