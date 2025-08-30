_: {
  services.avahi = {
    enable = true;
    nssmdns4 = true; # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns6 = true; # Enable mDNS for IPv6
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      workstation = true;
    };
  };
}
