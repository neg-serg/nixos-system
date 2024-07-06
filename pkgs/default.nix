{pkgs, ...}: {
  imports = [
    ./network
    ./system
    ./timesyncd
  ];

  programs = {
    atop = {enable = false;};
    mtr = {enable = true;};
    nano = {enable = false;}; # I hate nano to be honest
    zsh = {enable = true;};
    ssh = {
      startAgent = true;
      # agentPKCS11Whitelist = "/nix/store/*";
      # or specific URL if you're paranoid
      # but beware this can break if you don't have exactly matching opensc versions
      # between your main config and home-manager channel
      agentPKCS11Whitelist = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };

  services = {
    acpid.enable = true; # events for some hardware actions
    adguardhome.enable = true;
    autorandr.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    accounts-daemon.enable = true;
    chrony.enable = true;
    dbus.implementation = "broker";
    devmon.enable = true;
    earlyoom.enable = false; # may need it for notebook
    fwupd.enable = true;
    gnome = {gnome-keyring.enable = true;};
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
    logind = {extraConfig = ''IdleAction=ignore '';};
    openssh.enable = true;
    pcscd.enable = true;
    psd.enable = true;
    sysprof.enable = false; # gnome profiler ?
    udev.packages = with pkgs; [android-udev-rules];
    udisks2.enable = true;
    upower.enable = true;
    # Boot optimizations regarding filesystem:
    # Journald was taking too long to copy from runtime memory to disk at boot
    # set storage to "auto" if you're trying to troubleshoot a boot issue
    journald.extraConfig = ''
      Storage=auto
      SystemMaxFileSize=300M
      SystemMaxFiles=50
    '';
  };
}
