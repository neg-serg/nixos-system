{
  lib,
  config,
  ...
}: {
  # Roles enabled for this host
  roles = {
    workstation.enable = true;
    homelab.enable = true;
    media.enable = true;
  };
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
    # Local DNS rewrites for LAN names (service enable comes from roles)
    adguardhome.rewrites = [
      {
        domain = "telfir";
        answer = "192.168.2.240";
      }
      {
        domain = "telfir.local";
        answer = "192.168.2.240";
      }
    ];
    # Explicitly override media role to keep Jellyfin off on this host
    jellyfin.enable = false;
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
