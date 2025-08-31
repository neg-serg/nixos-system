{
  lib,
  config,
  ...
}:
# Host-specific kernel parameters for telfir.
# Keep host overrides here to avoid leaking hardware-tuned flags
# into other hosts (e.g. acpi_osi quirks and monitor modes).
let
  isHost = (config.networking.hostName or "") == "telfir";
in
  lib.mkIf isHost {
    # Ensure removable media auto-mount is enabled on this host
    hardware.storage.autoMount.enable = true;
    # Opt-in to bleeding-edge Mesa from Chaotic overlay on this host
    hardware.video.amd.useMesaGit = true;
    # Run flake checks on activation for this host
    flakePreflight.enable = true;

    # Disable auto-upgrade by default on this host
    system.autoUpgrade.enable = lib.mkForce false;

    # Disable automatic GC and optimise on this host
    nix = {
      gc.automatic = lib.mkForce false;
      optimise.automatic = lib.mkForce false;
      settings.auto-optimise-store = lib.mkForce false;
    };

    # Enable performance profile on this host
    profiles.performance.enable = true;

    # Enable server profiles on this host
    servicesProfiles = {
      adguardhome.enable = true;
      avahi.enable = true;
      jellyfin.enable = false; # keep previously disabled state
      mpd.enable = true;
      navidrome.enable = true;
      openssh.enable = true;
      syncthing.enable = true;
      unbound.enable = true;
      wakapi.enable = true;
      nextcloud.enable = true;
    };

    # Host-specific kernel parameters
    boot.kernelParams = [
      # ACPI OSI quirks: pretend to be "Linux" while disabling generic OSI
      # Helps some BIOS/firmware expose correct methods on certain laptops/desktops
      "acpi_osi=!"
      "acpi_osi=Linux"
      # Force preferred mode for this monitor (4K 240Hz). Adjust per hardware.
      "video=3840x2160@240"
    ];

    # Disable zswap and zram on this host to avoid double compression
    profiles.performance.zswap.enable = lib.mkForce false;
    zramSwap.enable = lib.mkForce false;

    # Nextcloud via Caddy on LAN, served as "telfir"
    services.nextcloud = {
      hostName = "telfir";
      caddyProxy.enable = true;
    };
    services.caddy.email = "serg.zorg@gmail.com";

    # Local name resolution on this host as well
    networking.hosts."192.168.2.240" = ["telfir" "telfir.local"];

    # Games autoscale defaults for this host: prefer 240 Hz targets but keep autoscale off
    profiles.games = {
      autoscaleDefault = false;
      targetFps = 240;
      nativeBaseFps = 240;
    };

    # Reserve two physical cores (both SMT threads) for gaming by banning them
    # from IRQ balancing. Assumes typical Zen3 numbering where sibling threads
    # are offset by +16: CPUs 14,15 and 30,31. Adjust if your topology differs.
    systemd.services.irqbalance.environment.IRQBALANCE_BANNED_CPUS = "0xC000C000";
  }
