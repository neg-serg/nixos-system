{
  lib,
  config,
  ...
}: {
  # Run flake checks on activation for this host
  flakePreflight.enable = true;

  # Host-specific system policy
  system.autoUpgrade.enable = lib.mkForce false;
  nix = {
    gc.automatic = lib.mkForce false;
    optimise.automatic = lib.mkForce false;
    settings.auto-optimise-store = lib.mkForce false;
  };

  # Service profiles toggles for this host
  servicesProfiles = {
    adguardhome.enable = true;
    avahi.enable = true;
    jellyfin.enable = false;
    mpd.enable = true;
    navidrome.enable = true;
    openssh.enable = true;
    syncthing.enable = true;
    unbound.enable = true;
    wakapi.enable = true;
    nextcloud.enable = true;
  };

  # Nextcloud via Caddy on LAN, served as "telfir"
  services.nextcloud = {
    hostName = "telfir";
    caddyProxy.enable = true;
  };
  services.caddy.email = "serg.zorg@gmail.com";

  # Games autoscale defaults for this host
  profiles.games = {
    autoscaleDefault = false;
    targetFps = 240;
    nativeBaseFps = 240;
  };
}

