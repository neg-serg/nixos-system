{ lib, config, ... }:
let
  cfg = config.servicesProfiles.avahi;
in {
  options.servicesProfiles.avahi.enable = lib.mkEnableOption "Avahi (mDNS) profile";

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true; # Needed for mDNS (IPv4)
      nssmdns6 = true; # Enable mDNS for IPv6
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
