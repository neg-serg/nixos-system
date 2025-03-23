{...}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true; # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };
}
