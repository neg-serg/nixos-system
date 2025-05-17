{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    inputs.raise.defaultPackage.${pkgs.stdenv.hostPlatform.system} # run-or-raise for hyprland
    xorg.xdpyinfo # display info
    xorg.xhost # install xhost to setup X11 ACL
  ];
  programs.kdeconnect.enable = true;
  programs.seahorse.enable = true; # program to manage gnome-keyring
  programs.hyprland = {
    enable = true;
    withUWSM  = true;
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
  };
}
