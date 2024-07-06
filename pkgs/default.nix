{...}: {
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
    devmon.enable = true;
    earlyoom.enable = false; # may need it for notebook
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    logind = {extraConfig = ''IdleAction=ignore '';};
    pcscd.enable = true;
    psd.enable = true;
    sysprof.enable = false; # gnome profiler ?
    udisks2.enable = true;
    upower.enable = true;
  };
}
