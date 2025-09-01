{lib, ...}: {
  # Disable heavy services in the VM to speed up eval/builds
  profiles.services = {
    nextcloud.enable = lib.mkForce false;
    adguardhome.enable = lib.mkForce false;
    syncthing.enable = lib.mkForce false;
    unbound.enable = lib.mkForce false;
    jellyfin.enable = lib.mkForce false;
    navidrome.enable = lib.mkForce false;
    wakapi.enable = lib.mkForce false;
  };

  # Lighten system for VM builds (docs off)
  documentation.enable = lib.mkDefault false;
}
